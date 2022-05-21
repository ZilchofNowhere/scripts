import os
import glob

for file in glob.glob("*.m4a"):
    name = file.removesuffix(".m4a")
    os.system(f"ffmpeg -i \"{name}.m4a\" \"{name}.mp3\"")
    print(f"Converted {name}")
