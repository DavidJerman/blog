---
category: tech
title: "Weather station"
date: 2021-05-06
image: /blog/media/d7223f_1620326443176.jpg
---

Here I will describe my weather station project, which can be accessed on this <a data-type="URL" href="http://weather.davidblog.si/" rel="noreferrer noopener" target="_blank"><s>weather.davidblog.si</s></a> [the weather station is not operational anymore]. The GitHub project can be accessed on this <a data-id="https://github.com/DavidJerman/WeatherStation" data-type="URL" href="https://github.com/DavidJerman/WeatherStation">URL</a>.

**Materials**

- Some wood, nails and paint for the weather station housing,
- Humidity and a temperature sensor (DHT22),
- Simple analog light sensor,
- Some LEDs as indicators,
- Arduino Uno (ATmega328P),
- Raspberry Pi B3+,
- Raspberry Pi Camera,
- Jumper wires,
- 220 Ohm resistors,
- Air pressure sensor (BMP180)*,
- Air quality sensor (MQ-135)*,
- RJ45 Ethernet cable,
- Power cable.

**The hardware**

The weather station consists of a simple wooden housing, which of course is painted white to prevent the weather station from heating. Inside the weather station there are two main components: the Arduino and the Raspberry Pi. Arduino has attached to it all of the mentioned sensors: the light sensor is located outside on a stick, as far away as possible so that the sunlight can reach the sensor as much as possible. Other sensors are located inside the housing and are all connected to the Arduino, which sends the data to the Raspberry Pi. The power and an the internet connection are supplied to the Arduino using cables. I also used plastic lens at the front where the camera is located to protect the camera from rain, snow etc.

**The software**

<div class="wp-block-media-text alignwide is-stacked-on-mobile" style="grid-template-columns:46% auto">

![Image](/blog/media/1384fa_kisspng-flask-by-example-web-framework-python-bottle-sebastian-estenssoro-5b6c0aa37f9672.5900311015338072675226.png)

<div class="wp-block-media-text__content">

The programming languages used in this project are Python, Arduino Language (C++) and HTML. The website was made using a python library Flask.

![Image](/blog/media/0cab74_learning-python-programming-language-computer-programming-logo-photo-studio-flex-design-83d33107704fdee4724eb4f0b354f569.png)

*Python logo*

</div></div>

**How does it work**

**The Arduino**

As mentioned, the Arduino was programmed using the Arduino language. The data was being measured multiple times and then the average of multiple measurements was taken and sent to the Raspberry Pi via the serial port. Here is an extract from the code, which measures the temperature, humidity, water level (the sensor is not mounter properly and thus does not actually measure anything) and the light level:

```c++
void loop() {
  delay(200);
  double light_avgs = 0;
  double water_avgs = 0;
  for (int i = 0; i < 20; i++) {
    double light_sum = 0;
    double water_sum = 0;
    for (int j = 0; j < 20; j++) {
      light_sum += analogRead(LIGHT_PIN)/1024.0;
      water_sum += analogRead(WATER_PIN)/256.0;
      delay(25);
    }
    
    water_avgs += water_sum/20.0;
    light_avgs += light_sum/20.0;
  }
  double water_average_lvl = water_avgs/20.0;
  double light_average_lvl = light_avgs/20.0;
  
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  if (isnan(h) || isnan(t)) {
    digitalWrite(LED_ON, 0);
    digitalWrite(LED_OFF, 1);
    delay(2000);
    digitalWrite(RESET, 1);
  }  
  digitalWrite(LED_ON, 1);
  digitalWrite(LED_OFF, 0);
  Serial.print("light:[");
  Serial.print(light_average_lvl);
  Serial.print("],water:[");
  Serial.print(water_average_lvl);
  Serial.print("],temp:[");
  Serial.print(t);
  Serial.print("],humidity:[");
  Serial.print(h);
  Serial.println("]");
}
```

The data is sent about every 10 seconds and if the data capturing on the Arduino fails, the Arduino resets and starts doing measurements again.

**Capturing data with Raspberry Pi**

A simple Python program captures and extracts the data from the Arduino via the serial connection and saves the obtained data in the SQL database. The data is not changed after being obtained except for the temperature measurements, which have to be changed to make them usable. Along each obtained data a timestamp is saved. This same program also maintains the database, deleting the old data - older than 3 days. If an error occurs - for example, if the Arduino fails to send the data - the program captures the error and retries capturing the data.  This is the code (a part of it) used in this program:

```python
while True:
    try:
        c += 1
        c4 += 1
        line = str(serial_connection.readline())
        print(line)
        # Get the date
        date = datetime.datetime.now(tz=timezone('Europe/Ljubljana'))
        year = int(date.strftime("%Y"))
        month = int(date.strftime("%m"))
        day = int(date.strftime("%d"))
        hour = int(date.strftime("%H"))
        minute = int(date.strftime("%M"))
        second = int(date.strftime("%S"))
        # Get values from the arduino data
        light = float(line.split("light:[")[1].split("]")[0])
        water = float(line.split("water:[")[1].split("]")[0])
        temp = float(line.split("temp:[")[1].split("]")[0])
        humidity = float(line.split("humidity:[")[1].split("]")[0])
        if temp < 0:
          temp += 3276.8
          temp = -temp
        # Insert into the database
        cursor.execute(f'''INSERT INTO data
         VALUES ({light}, {water}, {temp}, {humidity}, {year},
                 {month}, {day}, {hour}, {minute}, {second})''')
        connection.commit()
        # Delete old data (older than 3 days)
        if c == 1000:
            delete_old_data()
            c = 0
    except IndexError:
        print("Index error, trying to re-measure")
        sleep(2)
    except:
        pass
    finally:
        print("Collected: " + str(c4))
```

**Taking images with the camera**

Another python script takes care of taking images - a new image is taken every 61 seconds.  The Raspberry Pi camera has a decent quality, but the images are still compressed to save my internet bandwidth. The old photos are also deleted when new ones are taken to not occupy the Raspberry Pi storage. This is the Python code used:

```python
from picamera import PiCamera
from time import sleep
from PIL import Image
from datetime import datetime
import os
camera = PiCamera()
c = 0
while True:
    try:
        # Takes a new photo every 61 seconds and saves it for display
        c += 1
        year, month, day, hour, minute = datetime.now().strftime("%Y"), datetime.now().strftime("%m"),\
                                         datetime.now().strftime("%d"), datetime.now().strftime("%H"),\
                                         datetime.now().strftime("%M")
        for file in os.listdir("static/imgs"):
            os.remove("./static/imgs/" + file)
        name = "_" + year + "_" + month + "_" + day + "_" + hour + "_" + minute
        camera.start_preview()
        camera.capture(f"./static/imgs/view{name}.jpg")
        camera.stop_preview()
        picture = Image.open(f"./static/imgs/view{name}.jpg")
        picture.save(f"./static/imgs/view_compressed{name}.jpg", optimize=True, quality=90)
        os.remove(f'./static/imgs/view{name}.jpg')
        print("Image taken: " + str(c))
        sleep(61)
    except:
        print("Image could not be taken, an error occurred.")
```

**Making a plot with *matplotlib***

The temperature and humidity plots are created every 5 minutes for the past measurements. The graphs, data are also normalized, to make them nicer and more readable, as well as more reliable, since they are displaying averages over time. Here is and example of the temperature graph:

![Image](/blog/media/cb627f_plot_compressed_2021_05_06_22_30.jpg)

*Temperature graph*

**The website**

The website was created using Python and the Flask library. The HTML templates are really nothing special, just a simple website and Flask is responsible for displaying the data obtained from the SQL database. The website consists from of several pages: Download, About and the Main page. The main page displays the data, the download page allows the download of the SQL database and the About page says something about my website. Here is an example of the Flask About page code:

```python
@app.route("/about/")
def about():
    # About page
    try:
        return render_template(template_name_or_list='about.html')
    except Exception as e:
        return str(e)
```

And here is an example of the HTML page template:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="icon" href="{{ url_for('static', filename='other/web_icon.ico') }}">
    <title>About</title>
</head>
<body style="background-image: url({{ url_for('static', filename='other/bg.png') }});
                background-size: cover;
                height: 100%;
                width: 100%;
                margin: 0;
                padding-top: 20px">
    <center>
        <div style="text-align: center; width: 50%; padding: 20px">
            <h style="text-align: center; font-family: sans-serif; font-size: 28px;">
                About this website
            </h>
            <p style="font-family: sans-serif; font-size: 20px; padding-top: 10px;">
                This website was created as a hobby, as a part of a smaller project - A weather station.
                The aim of this project was to crate a small weather station and measure certain meteorological variables
                such as the temperature, humidity, brightness and additionally taking some photos of the surroundings.
                Data is obtained using a set of sensors hooked up to an arduino, which then sends its measurements to
                Raspberry Pi, which collects and saves the data into an sqlite database. This data is then displayed
                on this website. The source code and more about the project can be found
                <a href="https://github.com/DavidJerman/WeatherStation">here</a>.
            </p>
        </div>
    </center>
</body>
</html>
```

Essentially, the website displays the data semi-dynamically, that is the data is updated every couple of seconds and the image is updated every minute. One problem that I have come across is that sometimes the image does not get displayed on the website as a result of not being saved fast enough. A site reload saved the problem, but I should address this problem in the future.

**Conclusion**

In conclusion, with this project, I have made a weather station which captures various meteorological variables, saves them in a database and along with an image semi-dynamically displays them on the website. In the future I will add the two listed sensors, which were not explained in this blog to the weather station and update the website to display this additional data. What could certainly be optimized is the creation of a graph among some other things.

<a href=""></a>
