import click
from datetime import datetime, date
from czech_holidays import Holidays

now = datetime.now()

@click.command()
@click.argument("month", default=now.month)
@click.argument("year", default=now.year)
@click.option("--past", is_flag=True, default=False)
def main(year, month, past):
    holidays = Holidays(year)
    result = 0
    today = datetime.now().date()

    for day_number in range(1, 32):
        try:
            day = date(year, month, day_number)
        except ValueError:
            continue  # Out of range for the month

        is_not_weekend = day.weekday() < 5
        should_count = not past or day < today

        if day not in holidays and is_not_weekend and should_count:
            result += 1

    click.echo(result)

if __name__ == "__main__":
    main()
