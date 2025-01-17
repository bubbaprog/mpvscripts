#!/bin/zsh

# Check if the CSV file is passed as an argument
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <csv_file>"
  exit 1
fi

# File to process
csv_file=$1

# Read the CSV file line by line
{
  read -r header  # Read the header row
  # Remove carriage return (^M) characters from the header
  header=$(echo "$header" | tr -d '\r')
  # Split the header into an array
  headers=("${(@s/,/)header}")

  # Debug: Print the detected headers
  echo "Detected Headers: ${headers[@]}"

  # Map column names to indexes
  for i in {1..${#headers[@]}}; do
    case "${headers[$i]}" in
      "league") league_idx=$((i - 1)) ;;
      "file_name") file_name_idx=$((i - 1)) ;;
      "URL") url_idx=$((i - 1)) ;;
    esac
  done

  # Debug: Print detected indexes
  echo "league_idx: $league_idx, file_name_idx: $file_name_idx, url_idx: $url_idx"

  # Ensure required columns exist
  if [[ -z "$league_idx" || -z "$file_name_idx" || -z "$url_idx" ]]; then
    echo "Error: Required columns (league, file_name, URL) not found in header."
    exit 1
  fi

  # Process the remaining rows
  while read -r row; do
    # Remove carriage return (^M) from each row
    row=$(echo "$row" | tr -d '\r')
    # Split the row into an array
    fields=("${(@s/,/)row}")

    league="${fields[$((league_idx + 1))]}"
    file_name="${fields[$((file_name_idx + 1))]}"
    URL="${fields[$((url_idx + 1))]}"

    # Filter rows where "league" = "NHL" and "URL" is not empty
    if [[ "$league" == "NHL" && -n "$URL" ]]; then
      echo "Downloading $file_name from $URL..."
      download.sh "$URL" "$file_name"
    fi
  done
} < "$csv_file"
