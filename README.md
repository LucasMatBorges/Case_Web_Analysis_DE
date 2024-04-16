# Data Engineering assessment

## Context

Next to running a successfull training and consulting business, Xccelerated also runs a very real and totally 
non-fictitious webshop that sells all kinds of real products such as:

- Adaptive bi-directional analyzers;
- Yak shaving shears;
- Organic foreground paradigms;
- Intuitive asymmetric cores;
- Multi-lateral 6th-generation service-desk;
- and Seamless 4th-generation application.

Being a data-driven organization, we have many stakeholders who want to get their hands dirty
with data from this webshop in order to answer all kinds of analytical questions. 
Many of these analytical questions are based on the idea of a users "session". In particular, we'd like to know:

How much time does a user typically spend in our shop before committing to making a purchase
How many times does a user visit our shop before committing to making a purchase
Are there differences in session duration for sessions originating from different referrers

In order to answer these questions, the engineers who built our shop made sure to track user events. These events include:

- PAGE_VIEW
- ADD_PRODUCT_TO_CART
- REMOVE_PRODUCT_FROM_CART
- SIGN_UP_SUCCESS
- VISIT_RELATED_PRODUCT
- VISIT_RECENTLY_VISITED_PRODUCT
- VISIT_PERSONAL_RECOMMENDATION
- SEARCH

all events are stored with a timestamp, an event_type and additional event data in a json document. 
This event-data typically includes the users user-agent, ip address and customer-id if they are logged in.
Additionally, page-view events contain the url of the page the customer visited, as well as a referrer if 
they came from an external location.

A small sample of this data can be found below:

```json lines
{"id": 463469, "type": "search", "event": {"user-agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 14_2 like Mac OS X) AppleWebKit/532.0 (KHTML, like Gecko) FxiOS/14.7g5052.0 Mobile/28A193 Safari/532.0", "ip": "200.15.173.55", "customer-id": null, "timestamp": "2022-04-28T07:38:46.290271", "query": "Synchronized didactic task-force"}}
{"id": 452437, "type": "page_view", "event": {"user-agent": "Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3 like Mac OS X; br-FR) AppleWebKit/533.34.2 (KHTML, like Gecko) Version/4.0.5 Mobile/8B111 Safari/6533.34.2", "ip": "121.225.65.59", "customer-id": null, "timestamp": "2022-04-28T07:17:46.290271", "page": "https://xcc-webshop.com/cart"}}
{"id": 336904, "type": "page_view", "event": {"user-agent": "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10 9_9 rv:5.0; mk-MK) AppleWebKit/534.22.3 (KHTML, like Gecko) Version/5.1 Safari/534.22.3", "ip": "167.30.216.205", "customer-id": null, "timestamp": "2022-04-28T03:30:46.290271", "page": "https://xcc-webshop.com/cart"}}
{"id": 613891, "type": "page_view", "event": {"user-agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 5_1_1 like Mac OS X) AppleWebKit/535.2 (KHTML, like Gecko) CriOS/32.0.850.0 Mobile/39A486 Safari/535.2", "ip": "48.176.200.74", "customer-id": null, "timestamp": "2022-04-28T11:27:46.290271", "page": "https://xcc-webshop.com/category/6"}}
{"id": 309924, "type": "search", "event": {"user-agent": "Mozilla/5.0 (iPad; CPU iPad OS 3_1_3 like Mac OS X) AppleWebKit/533.0 (KHTML, like Gecko) FxiOS/16.2j6316.0 Mobile/60I472 Safari/533.0", "ip": "210.108.102.158", "customer-id": 2868, "timestamp": "2022-04-28T02:44:46.290271", "query": "Universal fault-tolerant system engine"}}
{"id": 484786, "type": "page_view", "event": {"user-agent": "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 5.01; Trident/5.0)", "ip": "44.137.154.180", "customer-id": null, "timestamp": "2022-04-28T08:15:46.290271", "page": "https://xcc-webshop.com/category/10"}}
{"id": 147927, "type": "page_view", "event": {"user-agent": "Mozilla/5.0 (Windows CE) AppleWebKit/535.0 (KHTML, like Gecko) Chrome/21.0.822.0 Safari/535.0", "ip": "189.207.78.72", "customer-id": null, "timestamp": "2022-04-25T03:27:46.290271", "page": "https://xcc-webshop.com/category/1"}}
{"id": 192099, "type": "search", "event": {"user-agent": "Mozilla/5.0 (compatible; MSIE 9.0; Windows 98; Win 9x 4.90; Trident/4.1)", "ip": "38.60.222.147", "customer-id": null, "timestamp": "2022-04-26T03:44:46.290271", "query": "Synergistic full-range strategy"}}
{"id": 77091, "type": "page_view", "event": {"user-agent": "Mozilla/5.0 (Windows NT 5.01) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/47.0.834.0 Safari/535.1", "ip": "190.76.145.129", "customer-id": null, "timestamp": "2022-04-22T05:42:46.290271", "page": "https://xcc-webshop.com/category/13"}}
{"id": 535920, "type": "search", "event": {"user-agent": "Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10 11_4 rv:2.0; ik-CA) AppleWebKit/535.28.3 (KHTML, like Gecko) Version/4.0.4 Safari/535.28.3", "ip": "49.131.75.24", "customer-id": null, "timestamp": "2022-04-28T09:42:46.290271", "query": "Decentralized uniform leverage"}}
{"id": 472670, "type": "page_view", "event": {"user-agent": "Mozilla/5.0 (Macintosh; PPC Mac OS X 10 7_9 rv:6.0; sa-IN) AppleWebKit/533.26.4 (KHTML, like Gecko) Version/5.0.1 Safari/533.26.4", "ip": "49.62.10.242", "customer-id": null, "timestamp": "2022-04-28T07:54:46.290271", "page": "https://xcc-webshop.com/category/9"}}
{"id": 626080, "type": "search", "event": {"user-agent": "Mozilla/5.0 (Macintosh; PPC Mac OS X 10 11_1; rv:1.9.6.20) Gecko/2011-02-17 04:20:01 Firefox/3.8", "ip": "185.187.224.184", "customer-id": null, "timestamp": "2022-04-28T11:38:46.290271", "query": "Ameliorated bifurcated paradigm"}}
{"id": 288558, "type": "visit_personal_recommendation", "event": {"user-agent": "Mozilla/5.0 (compatible; MSIE 6.0; Windows NT 5.01; Trident/3.0)", "ip": "50.83.159.117", "customer-id": null, "timestamp": "2022-04-28T00:23:46.290271", "product": 1685, "position": 3}}
{"id": 92845, "type": "page_view", "event": {"user-agent": "Opera/9.47.(X11; Linux x86_64; mai-IN) Presto/2.9.179 Version/10.00", "ip": "73.28.5.133", "customer-id": null, "timestamp": "2022-04-23T00:28:46.290271", "page": "https://xcc-webshop.com/category/7"}}
{"id": 78648, "type": "page_view", "event": {"user-agent": "Opera/8.90.(Windows NT 6.2; mag-IN) Presto/2.9.167 Version/12.00", "ip": "116.194.112.46", "customer-id": null, "timestamp": "2022-04-22T07:36:46.290271", "page": "https://xcc-webshop.com", "referrer": "https://gonzalez.com"}}
{"id": 373546, "type": "page_view", "event": {"user-agent": "Mozilla/5.0 (iPod; U; CPU iPhone OS 3_0 like Mac OS X; ast-ES) AppleWebKit/533.46.1 (KHTML, like Gecko) Version/3.0.5 Mobile/8B118 Safari/6533.46.1", "ip": "165.28.29.144", "customer-id": null, "timestamp": "2022-04-28T04:30:46.290271", "page": "https://xcc-webshop.com/category/3"}}
{"id": 44646, "type": "page_view", "event": {"user-agent": "Opera/8.28.(X11; Linux x86_64; an-ES) Presto/2.9.162 Version/12.00", "ip": "187.215.144.99", "customer-id": null, "timestamp": "2022-04-20T20:29:46.290271", "page": "https://xcc-webshop.com/category/12"}}
{"id": 488775, "type": "placed_order", "event": {"user-agent": "Opera/9.61.(Windows NT 6.0; ckb-IQ) Presto/2.9.184 Version/12.00", "ip": "62.222.197.54", "customer-id": 3024, "timestamp": "2022-04-28T08:22:46.290271"}}
{"id": 607799, "type": "page_view", "event": {"user-agent": "Mozilla/5.0 (X11; Linux x86_64; rv:1.9.6.20) Gecko/2019-09-06 09:51:12 Firefox/3.6.2", "ip": "214.135.165.151", "customer-id": null, "timestamp": "2022-04-28T11:21:46.290271", "page": "https://xcc-webshop.com/products/3553", "referrer": "https://gonzalez.com"}}
{"id": 132570, "type": "page_view", "event": {"user-agent": "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.2; Trident/5.1)", "ip": "24.21.50.140", "customer-id": null, "timestamp": "2022-04-24T17:11:46.290271", "page": "https://xcc-webshop.com/category/6"}}
```

If you put all these events on a timeline for each user, you will find short periods of high activity, 
followed by longer periods of inactivity. 

![](images/timeline.png)


These high activity periods can be considered as a users' session.

![](images/sessions.png)

## The assignment
### Step 1: Sessionize

In order to facilitate self-service analysis by our stakeholders we want to perform a preprocessing step
in which we group related events from a user into a session. We'll only focus on easily identifiable customers
that have logged in (e.g. have a not-null customer-id)

The output of this step should be stored in an SQL database for further analysis, preferably PostgreSQL 
([running in Docker for example](https://hub.docker.com/_/postgres)) but SQLite is also acceptable. You are free to design
the database schema as you see fit.

The data can be retrieved from https://storage.googleapis.com/xcc-de-assessment/events.json. 
You are free to use any python library or framework you see fit to process: <b>Vanilla Python</b> lists dicts and tuples, 
of course! if <b>Pandas</b> is your thing, go for it. If you'd rather do <b>Spark</b>, that's fine as well.
It is not necessary to complete this assessment in a particular BigData(TM) tool to pass. Make sure to think about 
the up- and downsides of your choice though and please do not use raw sql scripts. 


### Step 2: Publish your results

The user session data you generated in step one can be used to drive many important processes for our webshop. 
We'd like to make the most essential information available through a web API. We'd like you to implement the 
following endpoint:

```
GET /metrics/orders
Response:
{
    "median_visits_before_order": ...
    "median_session_duration_minutes_before_order": ...
}
```

The first metric here should return the median amount of sessions someone had before they had a session in which they made a purchase. 
The second metric does the same except it returns the median session duration someone had before the first session in which they had a purchase.

![](images/metrics.png)

This endpoint should fetch the processed session data from your SQL database and use raw SQL to transform it into the two 
defined metrics. [Windows functions](https://www.postgresql.org/docs/current/tutorial-window.html) will come in very
handy for this part of the assessment. We expect some raw SQL here either through SQL scripts or executing SQL through python. Please do not use an ORM to provide the functionality.


## Evaluation
The evaluation of your solution is based on a presentation given by you for two members of our team and on the solution itself.
Please provide us with the working solution beforehand (short notice is OK, doesn’t have to be weeks before) by
pushing it to this GitHub repository.

We care about your ability to create a data driven solution that is useful for end users. In the end we are about
creating software for our clients that will help them improve their organization. The result should fit that description.

There are no strict rules regarding choice of frameworks or tools. Since the main programming language for the 
Xccelerated program is Python, we do expect you to use Python as your main implementation language. 

We do care about Software Engineering best practices. Things like automation, separation of concerns, testability, etc.
We are not religious about any certain technology. Mixing of languages and tools where it makes sense is rather encouraged over forcing everything onto a single technology. 
You get the point. We want to see that you are capable of building a (simple) product, end-to-end.

Your solution must work out-of-the-box. This means that an individual reasonably proficient with computers and programming
should be able to get it running without having to contact you. A useful README must be in place if this is 
required to meet this requirement, but don't go overboard with documentation. Assume we know how to create virtual 
environments, run docker containers and start python scripts.

Your solution must be runnable on Linux or Apple OS X. A solution that only runs on Microsoft Windows is not
acceptable (this is for practical reasons; we hold nothing against Microsoft ope-rating systems).


## Timeframe
If you can make the assessment in approximately 10 to 15 hours of work that is a good sign . 
If you need a little more that’s ok too. However, do not spend a lot more hours on it. It’s better to 
deliver something simple and working than nothing at all. 

Also, let us know if you feel that the time estimate is inaccurate. This feedback is valuable for us. 


## Questions:

If you have any questions, please reach out to our CTO Matthijs at mbrouns@xccelerated.io, or our DE Lead Rick at
rvergunst@xccelerated.io
