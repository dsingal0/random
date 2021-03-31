import praw
import configparser
import gi

gi.require_version("Notify", "0.7")
from gi.repository import Notify


def get_title(submission):
    return submission.title


def get_selftext(submission):
    return submission.selftext


def main():
    config = configparser.ConfigParser()
    config.read("reddit_bot.ini")
    print(config.sections)
    reddit = praw.Reddit(
        client_id=config["hardwareswap"]["client_id"],
        client_secret=config["hardwareswap"]["client_secret"],
        user_agent=config["hardwareswap"]["user_agent"],
    )
    # start loop
    Notify.init("hardwareswap scraper")
    notification = Notify.Notification.new("starting to scrape hardwareswap")
    notification.show()
    old_title = None
    while True:
        try:
            submissions = reddit.subreddit("hardwareswap").new(limit=1)
            title = [submission.title for submission in submissions]
            # url = [submission.url for submission in submissions]
            if len(title) < 1:
                continue
            else:
                title = title[0]
            """if len(url) < 1:
                continue
            else:
                url=url[0]
            """
            if title == old_title:
                continue
            old_title = title
            title = title.split("[W]")[0]
            searching_for = [
                "psu",
                "PSU",
                "980",
                "3060",
                "1060",
                "1070",
                "1050",
                "1080",
                "1650",
                "1660",
            ]
            for item in searching_for:
                if item in title:
                    print(title)
                    notification.update(title)
                    # Show
                    notification.show()
        except praw.exceptions.PRAWException:
            continue


if __name__ == "__main__":
    main()
