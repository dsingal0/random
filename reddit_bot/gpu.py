import praw
import configparser
import webbrowser
from sys import platform
import os
import argparse
from time import sleep


def find(name, path):
    for root, dirs, files in os.walk(path):
        if name in files:
            return os.path.join(root, name)


parser = argparse.ArgumentParser(
    description="Buying and Selling hardware on reddit.com/r/hardwareswap"
)

parser.add_argument("-b", "--buy", help="enable buying")

parser.add_argument("-s", "--sell", help="enable selling")

parser.add_argument("-r", "--retrospect", help="look back in time")

args = parser.parse_args()


def str2bool(v):
    if isinstance(v, bool):
        return v
    if v.lower() in ("yes", "true", "t", "y", "1"):
        return True
    elif v.lower() in ("no", "false", "f", "n", "0"):
        return False
    else:
        raise argparse.ArgumentTypeError("Boolean value expected.")


is_selling, is_buying, is_retrospect = (
    str2bool(args.sell),
    str2bool(args.buy),
    str2bool(args.retrospect),
)

selling = ["egpu", "razer core"]
buying = ["1660","3060","3050","2070","2080","2060"]
page_url = "http://example.com/"
disqualifying_words_buy = ["laptop", "desktop", "prebuilt"]


def open_url():
    try:
        webbrowser.open_new(page_url)
        print("Opening URL...")
    except:
        print("Failed to open URL. Unsupported variable type.")


def linux_init(text):
    return


def windows_init(text):
    return


def linux_notification(notifier, text, url=None):
    global page_url
    page_url = url
    open_url()
    return


def windows_notification(notifier, text, url=None):
    global page_url
    page_url = url
    open_url()
    return


def generic_notification(notifier, text, url=None):
    if platform == "win32":
        windows_notification(notifier, text, url)
    elif platform == "linux":
        linux_notification(notifier, text, url)
    return


def generic_init(text):
    notifier = None
    if platform == "win32":
        notifier = windows_init(text)
    elif platform == "linux":
        notifier = linux_init(text)
    return notifier


def get_title(submission):
    return submission.title


def get_url(submission):
    return submission.url


def get_id(submission):
    return submission.id


def get_selftext(submission):
    return submission.selftext


def run_rules(submission, old_id, notifier):
    title = get_title(submission).lower()
    url = get_url(submission)
    id = get_id(submission)
    # body=get_selftext(submission)
    if id == old_id:
        return id
    old_id = id
    have_want_tuple = title.split("[w]")
    # don't let program die if poorly formatted title
    if len(have_want_tuple) < 2:
        return old_id
    have, want = have_want_tuple[0], have_want_tuple[1]
    # CA only
    # if "usa-ca" not in have:
    #    return old_id
    # disqualify if bad listing
    bad_link = False
    if is_buying:
        for item in disqualifying_words_buy:
            if item in have:
                bad_link = True
                break
    if bad_link == True:
        return old_id
    if is_buying:
        for item in buying:
            if item in have:
                # if "paypal" not in want:
                #    if "usa-ca" not in have:
                #        return old_id
                print(have, want, item)
                generic_notification(notifier, have, url)
                break
    if is_selling:
        for item in selling:
            if item in want:
                print(have, want, item)
                generic_notification(notifier, have, url)
                break
    return old_id


def main():
    config = configparser.ConfigParser()
    path = os.getcwd()
    file = "reddit_bot.ini"
    config_path = find(file, path)
    print("reading config file from: ", config_path)
    config.read(config_path)
    print(config.sections)
    reddit = praw.Reddit(
        client_id=config["hardwareswap"]["client_id"],
        client_secret=config["hardwareswap"]["client_secret"],
        user_agent=config["hardwareswap"]["user_agent"],
    )
    # start loop
    notifier = generic_init("hardwareswap scraper")
    old_id = None
    if is_retrospect == True:
        # get 100 past posts
        submissions = list(reddit.subreddit("hardwareswap").new(limit=100))
        for submission in submissions:
            old_id = run_rules(submission, old_id, notifier)
    while True:
        try:
            submission = list(reddit.subreddit("hardwareswap").new(limit=1))[0]
            old_id = run_rules(submission, old_id, notifier)
            sleep(2)
        except praw.exceptions.PRAWException:
            continue


if __name__ == "__main__":
    main()
