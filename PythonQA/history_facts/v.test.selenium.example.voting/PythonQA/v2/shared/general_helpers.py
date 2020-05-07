import random
import string


def generate_random_name(length=32):
	return ''.join(random.choice(string.ascii_lowercase + string.digits) for _ in range(length))


# from https://gist.github.com/seanh/93666
def format_filename(s):
	valid_chars = "-_.() %s%s" % (string.ascii_letters, string.digits)
	filename = ''.join(c for c in s if c in valid_chars)
	filename = filename.replace(' ', '_')
	return filename
