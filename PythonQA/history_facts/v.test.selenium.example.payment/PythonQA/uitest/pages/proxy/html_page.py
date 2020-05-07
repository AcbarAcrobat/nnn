import sys


class HtmlPage:

    def __init__(self, driver):
        self.driver = driver

    def generate(self, env, encoded):
        f = open(sys.path[0] + '/uitest/pages/proxy/test.html', 'w')
        message = """<!DOCTYPE html>
        <html lang="en">
        <head>
        </head>
        <body>
          <form id="payForm" action="{}/api/v1/purchase" method="post">
            <input type="hidden" name="request" value={}/>
          </form>
          <script>
            document.getElementById("payForm").submit();
          </script>
        </body>
        </html>""".format(env['PROXY'], encoded)
        f.write(message)
        f.close()

    def open(self):
        self.driver.get('file:///' + sys.path[0] + '/uitest/pages/proxy/test.html')

