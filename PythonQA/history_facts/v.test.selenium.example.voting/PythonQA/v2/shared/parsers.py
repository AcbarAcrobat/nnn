from behave import register_type
import parse


@parse.with_pattern(r"\[.*\]")
def parse_array(text):
    return [] if text == '[]' else list(map(str.strip, text[1:-1].split(',')))

register_type(array=parse_array)