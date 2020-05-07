FROM python

ENV APP_NAME /PythonQA

ENV PYTHONUNBUFFERED 1
WORKDIR /$APP_NAME

RUN	apt-get update -qq \
    && apt install -qq -y --no-install-recommends wget \
    && apt install fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 libgtk-3-0 libnspr4 libnss3 libx11-xcb1 libxtst6 lsb-release xdg-utils -y -f\
    && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb \
    && apt-get update -qq \
    && apt-get install -qq -y --no-install-recommends google-chrome-stable \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get install google-chrome-stable -y

COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . /$APP_NAME
