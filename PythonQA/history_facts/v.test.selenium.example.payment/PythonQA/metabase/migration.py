import os
import sys
import ast
import json
import yaml
import unittest
import warnings
#from metabase import main
import main


class MetaMigrate(unittest.TestCase):

    def test_migrate(self):
        base = session()
        collection_list = base.get('/collection/')
        collection_id = collection(collection_list, base)
        card_list = base.get('/collection/' + str(collection_id) + '/items')
        id_list = []
        try:
            cards = json.loads(str(json.dumps(ast.literal_eval(str(card_list[1])))))
            for list in range(0, len(cards)):
                if 'test_' in cards[list]['name']:
                    id_list.append(cards[list]['id'])
            for archive in id_list:
                base.delete('/card/' + str(archive))
        except KeyError:
            pass
        with open(sys.path[0] + '/package.json') as f:
            data = json.load(f)
        for list in range(0, len(data['business'])):
            data['business'][list]['collection_id'] = collection_id
            base.post('/card/', json=data['business'][list])
        for list in range(0, len(data['core'])):
            data['core'][list]['collection_id'] = collection_id
            base.post('/card/', json=data['core'][list])


def collection(collection_list, base):
    collection_id = False
    i = 0
    while not collection_id:
        for list in range(0, len(collection_list[1])):
            name = collection_list[1][list]['name']
            i += 1
            if name == 'Auto Tests':
                collection_id = collection_list[1][list]['id']
                return collection_id
            elif i == len(collection_list[1]) and name != 'Auto Tests':
                data = {"name": "Auto Tests", "color": "#ff6685"}
                base.post('/collection/', json=data)
                break
        return collection_id


#collection_delete(collection_list, base)  DO NOT TOUCH :(
def collection_delete(collection_list, base):
    data = {"archived": True}
    id_list = []
    for list in range(0, len(collection_list[1])):
        id_list.append(collection_list[1][list]['id'])
    for list in id_list:
        base.put('/collection/' + str(list), json=data)


def session():
    warnings.filterwarnings("ignore", category=ResourceWarning)
    #config = yaml.safe_load(open('../env.yml'))
    #env = config['environment']
    env = os.environ
    session_id = main.Base(env=env).session
    base = main.Base(session=session_id, env=env)
    return base


if __name__ == "__main__":
    unittest.main()

