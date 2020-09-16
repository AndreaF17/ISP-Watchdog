# ISP-Watchdog
This is a project to have a fully functional Watchdog for your download/upload speed and ping that saves all the information inside a mysql DB.
So if you want to argue to your ISP now you have real data traked over the time.

## Requirement
- Any Raspberry/Computer with an ethernet adapter for more consistet data. (I used an Raspberry PI 4)
- Any Linux Distrio (I used Ubuntu 18.04.4 LTS)

### Software required
- Server LAMP
- python-pip
- speedtest-cli

### Installation and Set-up
- Clone the repository
- Import the db into the SQL Database
- Create a SQL user and give the privilage to edit just the imported db
- Edit the file ISP-Whatchdog/speedtest-sql.sh and set-up the SQL-USER details
- Open the terminal and try to run ./ISP-Watchdog/speedtest-sql.sh
- Open the terminal and write "crontab -e"
- write @daily ~/ISP-Watchdog/speedtest-sql.sh
- Restart the computer

#### Thanks to Henrik Bengtsson for speedtest-cli-extras
Original directory of speedtest-cli-extras: https://github.com/HenrikBengtsson/speedtest-cli-extras






