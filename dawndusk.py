import astral
import datetime

city = astral.LocationInfo('Nottingham', 'England', 'Europe/London', 52.55, -1.48) 

from astral.sun import sun
s = sun(city.observer, date=datetime.datetime.now())
f = open("dawndusk.txt", "w")
f.write((
    f'export Dawn="{s["dawn"]}"\n'
    f'export Dusk="{s["dusk"]}"\n'
))
f.close()
