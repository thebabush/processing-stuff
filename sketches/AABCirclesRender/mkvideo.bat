% ffmpeg -thread_queue_size 512 -framerate 60 -start_number 30 -i ./video/snap-%%08d.jpg -i "Aphex Twin - Flim.mp3" -vframes 240 -vcodec libx264 video.mp4
ffmpeg -thread_queue_size 1024 -framerate 60 -start_number 30 -i ./video/snap-%%08d.jpg -i "Aphex Twin - Flim.mp3" -vframes 5160 -vcodec libx264 video.mp4
