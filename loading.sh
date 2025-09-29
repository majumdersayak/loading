#!/bin/bash

# Default store for downloaded files
DOWNLOAD_DIR="$HOME/Downloads"

while true; do
  clear
  cat << "EOF"

██╗      ██████╗  █████╗ ██████╗ ██╗███╗   ██╗ ██████╗ 
██║     ██╔═══██╗██╔══██╗██╔══██╗██║████╗  ██║██╔════╝ 
██║     ██║   ██║███████║██║  ██║██║██╔██╗ ██║██║  ███╗
██║     ██║   ██║██╔══██║██║  ██║██║██║╚██╗██║██║   ██║
███████╗╚██████╔╝██║  ██║██████╔╝██║██║ ╚████║╚██████╔╝
╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ 
                                                                                                                  
    [Download media files from Internet]
EOF
    # First set of choices for users
    echo ""
    echo "1) Download media files from Internet"
    echo "2) Exit"
    echo ""
    read -p "Select option: " option
    case $option in 
      1) 
      # Choice for what user want to download
        echo ""
        echo "1) Download best Video (MP4)"
        echo "2) Download best audio (MP3)"
        echo "3) Choose format manually (Only available formats)"
        echo "4) Exit"
        echo ""
        read -p "Select option: " option1 
        # Make the choice executable
        case $option1 in 
          1) 
            read -p "Enter URL: " url 
            read -p "Save to folder [default: $DOWNLOAD_DIR]: " savepath
            savepath=${savepath:-$DOWNLOAD_DIR}
            mkdir -p "$savepath"
            echo "Downloading best video + audio as MP4..."
            yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mp4 -o "$savepath/%(title)s.%(ext)s" "$url"
            ;;
          2)
            read -p "Enter URL: " url
            read -p "Save to folder [default: $DOWNLOAD_DIR]: " savepath
            savepath=${savepath:-$DOWNLOAD_DIR}
            mkdir -p "$savepath"
            echo "Downloading best audio as MP3..."
            yt-dlp -x --audio-format mp3 -o "$savepath/%(title)s.%(ext)s" "$url"
            ;;
          3)
            read -p "Enter URL: " url 
            echo "Fetching available formats..."
            yt-dlp -F "$url"
            echo ""
            read -p "Enter format code (e.g., 22): " fmt 
            read -p "Save to folder [default: $DOWNLOAD_DIR]: " savepath
            savepath=${savepath:-$DOWNLOAD_DIR}
            mkdir -p "$savepath"
            yt-dlp -f "$fmt" -o "$savepath/%(title)s.%(ext)s" "$url"
            ;;
          4)
            echo "Returning to main menu..."
            ;;
          *)
            echo "Invalid choice. Try again."
            ;;
        esac 
        ;;
      2)
      # Exit the program
        echo "Goodbye!"
        exit 0
        ;;
    esac
    echo ""
    read -p "Press Enter to continue..." dummy
done
