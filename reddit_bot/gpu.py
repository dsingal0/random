import praw
import configparser
import webbrowser
from sys import platform

page_url = "http://example.com/"
searching_for = [
    "egpu",
    "razer core",
    "core x",
    "tkl",
    "60%",
    "ducky",
    "k65",
    "gk61",
    "keychron",
    "980",
    "1050",
    "1060",
    "1070",
    "1080",
    "1650",
    "1660",
    "2060",
    "2070",
    "2080",
    "3060",
    "3070",
    "3080",
]


def open_url():
    try:
        webbrowser.open_new(page_url)
        print("Opening URL...")
    except:
        print("Failed to open URL. Unsupported variable type.")


def linux_init(text):
    import gi

    gi.require_version("Notify", "0.7")
    from gi.repository import Notify

    Notify.init(text)
    return Notify


def windows_init(text):
    import webbrowser
    from win10toast_click import ToastNotifier

    toaster = ToastNotifier()
    toaster.show_toast(text)
    return toaster


def linux_notification(notifier, text, url=None):
    return


def windows_notification(notifier, text, url=None):
    global page_url
    page_url = url
    notifier.show_toast(
        text,
        url,
        icon_path=None,
        duration=None,
        threaded=True,
        callback_on_click=open_url,
    )
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
    notifier = generic_init("hardwareswap scraper")
    old_title = None
    while True:
        try:
            submission = list(reddit.subreddit("hardwareswap").new(limit=1))[0]
            title = get_title(submission).lower()
            url = get_url(submission)
            # body=get_selftext(submission)
            if title == old_title:
                continue
            old_title = title
            have_want_tuple = title.split("[w]")
            # don't let program die if poorly formatted title
            if len(have_want_tuple) < 2:
                continue
            have, want = have_want_tuple[0], have_want_tuple[1]
            for item in searching_for:
                if item in have:
                    if "paypal" not in want:
                        if "usa-ca" not in have:
                            continue
                    print(have, want, item)
                    generic_notification(notifier, have, url)
        except praw.exceptions.PRAWException:
            continue


if __name__ == "__main__":
    main()
