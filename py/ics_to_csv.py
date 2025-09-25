import argparse
from dateutil import parser as dtparser
import csv
from collections import defaultdict
import os

def parse_ics(file_path):
    events = []
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    event = {}
    inside_event = False

    for line in lines:
        line = line.strip()
        if line == "BEGIN:VEVENT":
            inside_event = True
            event = {}
        elif line == "END:VEVENT":
            inside_event = False
            events.append(event)
        elif inside_event:
            if ":" in line:
                key, value = line.split(":", 1)
                key = key.split(";")[0]
                event[key] = value
    return events

def parse_datetime(dt_str):
    if not dt_str:
        return None
    try:
        return dtparser.parse(dt_str)
    except Exception:
        return None

def calculate_hours(start, end):
    if start is None or end is None:
        return 0
    delta = end - start
    return round(delta.total_seconds() / 3600, 2)

def write_csv_per_year(events, output_prefix, specific_year=None):
    # Group events by year
    events_by_year = defaultdict(list)
    for event in events:
        start_dt = parse_datetime(event.get("DTSTART", ""))
        end_dt = parse_datetime(event.get("DTEND", ""))
        total_hours = calculate_hours(start_dt, end_dt)
        job_type = "FULL" if total_hours > 6 else "HALF"

        row = {
            "TITLE": event.get("SUMMARY", ""),
            "START": start_dt.strftime("%Y-%m-%d %H:%M:%S") if start_dt else "",
            "END": end_dt.strftime("%Y-%m-%d %H:%M:%S") if end_dt else "",
            "TOTAL_HOURS": total_hours,
            "JOB_TYPE": job_type
        }

        year = start_dt.year if start_dt else "Unknown"
        events_by_year[year].append(row)

    # Write CSV per year
    for year, rows in events_by_year.items():
        if specific_year and int(specific_year) != int(year):
            continue  # Skip other years

        output_file = f"{output_prefix}_{year}.csv"
        total_hours_sum = sum(r["TOTAL_HOURS"] for r in rows)
        full_count = sum(1 for r in rows if r["JOB_TYPE"] == "FULL")
        half_count = sum(1 for r in rows if r["JOB_TYPE"] == "HALF")

        summary_row = {
            "TITLE": "TOTAL / COUNT",
            "START": "",
            "END": "",
            "TOTAL_HOURS": total_hours_sum,
            "JOB_TYPE": f"FULL: {full_count}, HALF: {half_count}"
        }
        rows.append(summary_row)

        fieldnames = ["TITLE", "START", "END", "TOTAL_HOURS", "JOB_TYPE"]
        with open(output_file, 'w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            for r in rows:
                writer.writerow(r)
        print(f"Saved {output_file} ({len(rows)-1} events + summary)")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert .ics to yearly CSV files with totals")
    parser.add_argument("-i", "--input", type=str, default="calendar.ics", help="Input .ics file")
    parser.add_argument("-o", "--output_prefix", type=str, default="calendar", help="Output file prefix")
    parser.add_argument("-y", "--year", type=int, help="Only export specific year (optional)")
    args = parser.parse_args()

    events = parse_ics(args.input)
    write_csv_per_year(events, args.output_prefix, specific_year=args.year)
