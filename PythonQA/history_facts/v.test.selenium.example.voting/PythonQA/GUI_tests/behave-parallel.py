#!/usr/bin/env python3

# modified https://gist.github.com/remcowesterhoud/f581b6b69587832da41507ab369f8b3c
"""
Behave runner for running features asynchronously.
"""
import argparse
import json
import logging
import os
import shutil
from functools import partial
from glob import glob
from multiprocessing import Pool
from subprocess import call, Popen, PIPE

from shared.constants import PATH_TO_EMAILS

logging.basicConfig(level=logging.INFO,
                    format="[%(levelname)-8s %(asctime)s] %(message)s")
logger = logging.getLogger(__name__)


def parse_arguments():
    """
    Parses commandline arguments
    :return: Parsed arguments
    """
    parser = argparse.ArgumentParser('Run Behave feature files in parallel mode')
    parser.add_argument('--processes', '-p', type=int, help='Maximum number of processes. Default = 5', default=5)
    parser.add_argument('--verbose', '-v', action='store_true', help='verbose output')
    parser.add_argument('--tags', '-t', help='specify behave tags to run')
    parser.add_argument('--define', '-D', action='append', help='Define user-specific data for the config.userdata '
                                                                'dictionary. Example: -D foo=bar to store it in '
                                                                'config.userdata["foo"].')
    args = parser.parse_args()
    return args


def _run_feature(feature, tags=None, userdata=None):
    """
    Runs features matching given tags and userdata
    :param feature: Feature that should be run
    :type feature: str
    :param tags: Tags features should contain
    :type tags: str
    :param userdata: Userdata for behave
    :type userdata: list
    :return: Feature and status
    """
    logger.debug("Processing feature: {}".format(feature))
    feature = feature.replace("\\", "(\\\\|/)")
    if not userdata:
        params = "--tags={0} --no-capture --no-skipped".format(tags)
    else:
        params = "--tags={0} -D {1} --no-capture --no-skipped".format(tags, ' -D '.join(userdata))
    logger.debug("Running feature {} with params {}".format(feature, params))
    cmd = 'behave -f teamcity {0} -i "{1}" --no-summary'.format(params, feature)
    logger.debug(cmd)
    r = call(cmd, shell=True)
    status = 'ok' if r == 0 else 'failed'
    return feature, status


def main():
    #  Clean .emails folder
    shutil.rmtree(os.path.join(*PATH_TO_EMAILS), ignore_errors=True)
    """
    Runner
    """
    args = parse_arguments()
    pool = Pool(args.processes)
    if args.tags:
        p = Popen('behave -d -f json --no-summary -t {}'.format(args.tags),
                  stdout=PIPE, shell=True)
        out, err = p.communicate()
        out_text = out.decode()
        try:
            j = json.loads(out_text)
        except json.JSONDecodeError:
            # crutch by Dzmitry Skorobogatov
            raise Exception(out_text)

        features = [e['location'].replace(r'features/', '')[:-2] for e in j]
    else:
        feature_files = glob('features/*.feature') + glob('features/**/*.feature')
        features = [x.replace('features/', '') for x in feature_files]
    run_feature = partial(_run_feature, tags=args.tags, userdata=args.define)
    logger.debug("Found {} features".format(len(features)))
    logger.debug(features)
    # features = [f for f in features if 'aft' not in f]
    for feature, status in pool.map(run_feature, features):
        print("{0:50}: {1}".format(feature, status))


if __name__ == '__main__':
    main()
