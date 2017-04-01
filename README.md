# channel-dl
The purpose of this script is to use youtube-dl to download videos from a list of "subscriptions" stored locally on your computers. All config is in the .channel-dl/channels file.(There will be a config for other settings in the future.)
The first time you run it it will check your list of channels and update the database with all previously uploaded videos. The next time you run it, it will find any newly uploaded videos from your list of channels and download them.

There are 4 different quality settings. high, medium, low, and audio and their use is demonstrated in the default .channel-dl/channels file.

CAUTION: When you add new channels to the list you will need to delete the .channel-dl/db file.