from robot.api import logger
from robot.api.deco import keyword
from random import randint


@keyword("Generate Random Number")
def generate_random_number(int_a, int_b):
    number = randint(int(int_a), int(int_b))
    logger.info("generated the number: %s" % str(number))
    return number
