a<-5
a
90

##################Spark######################

# coding: utf-8

# In[1]:

#Set the SQL/Hive Context
from pyspark.sql import SQLContext
from pyspark.sql import HiveContext
from pyspark.sql import Row, functions as F
from pyspark.sql.window import Window
from pyspark.sql.types import *
from pyspark.sql.functions import from_unixtime, unix_timestamp
#from pyspark.sql.types import TimestampType

#sqlContext = SQLContext(sc)
sqlContext = HiveContext(sc)


# In[2]:

#Load the json file
webdf = sqlContext.read.json("D:/INSOFE/Big Data/Project/*.json")
#webdf = sqlContext.read.json("hdfs://localhost:8020/INSOFE/Big Data/Project/*.json")


# In[3]:

#Print dataframe schema
#webdf.printSchema()


# In[4]:

#Print complete data frame output
#webdf.show()


# In[5]:

#Print just column c
#webdf.select(webdf['u']).show()


# In[6]:

#Derive only country, URL & Timestamp columns
df1 = webdf.select(webdf['c'],webdf['u'],webdf['t'])
#df.show()


# In[7]:

#Convert all the columns to string types
strdf = df1.selectExpr("cast(c AS STRING)", "cast(u AS STRING)", "cast(t AS STRING)")

#Convert unix timestamp format to date time format
df = strdf.select(strdf['cast(c AS STRING)'].alias("c"),strdf['cast(u AS STRING)'].alias("u"),strdf['cast(t AS STRING)'].alias("t"),from_unixtime(strdf['cast(t AS STRING)'],format='YYYY-MM').alias("new_ts"))


# In[8]:

#Count the total rows
#df.count()


# In[9]:

#Get count of rows with incomplete data
#df.filter(df['tz']=='').count()


# In[10]:

#Group the data by URLs and get the click count for each URL
topWeb = df.groupBy(df['u']).count()
#topWeb.describe()

#Filter out URLs with null and empty strings. Sort them by descreasing order of click counts. Show only top 10
Top10Web = topWeb.filter((topWeb['u']!="null") & (topWeb['u']!="")).sort(topWeb['count'].desc()).limit(10)


# In[11]:

#Convert Spark dataframe to Pandas dataframe and export to a csv
Top10Web.toPandas().to_csv('D:/INSOFE/Big Data/Project/TopWebsites.csv', index=False)
#Top10Web.write.parquet("D:/INSOFE/Big Data/Project/TopWebsites")


# In[12]:

#Group the data by Countries and URLs and get the click count for each URL
CWeb = df.groupBy(df['c'],df['u']).count()

#Filter out URLs with null and empty strings. Sort them by descreasing order of click counts. Show only top 10
sortedCWeb = CWeb.filter((CWeb['u']!="null") & (CWeb['u']!="") & (CWeb['c']!="null") & (CWeb['c']!="")).sort(CWeb['c'],CWeb['count'].desc())


# In[13]:

#Add a new row that ranks URLs partitioned by country sorted by descreasing order of no. of clicks
rankedCWeb = sortedCWeb.select(sortedCWeb['c'],sortedCWeb['u'],sortedCWeb['count'],F.rowNumber().over(Window.partitionBy(sortedCWeb['c']).orderBy(sortedCWeb['count'].desc())).alias("RowNum"))


# In[14]:

#Exclude all records with rank > 11 since we only need top 10 for each country
topCountry = rankedCWeb.filter(rankedCWeb['RowNum'] < 11).sort(rankedCWeb['c'],rankedCWeb['RowNum'])


# In[15]:

#Include only those columns that are needed in the output with proper aliasing
tc = topCountry.select(topCountry['c'].alias("Country"), topCountry['u'].alias("URL") ,topCountry['count'])


# In[16]:

#Convert Spark dataframe to Pandas dataframe and export to a csv
tc.toPandas().to_csv('D:/INSOFE/Big Data/Project/TopWebsitesByCountries.csv', index=False)


# In[17]:

#Group the data by Months and URLs and get the click count for each URL
tWeb = df.groupBy(df['new_ts'],df['u']).count()

#Filter out URLs with null and empty strings. Sort them by descreasing order of click counts. Show only top 10
sortedtWeb = tWeb.filter((tWeb['u']!="null") & (tWeb['u']!="")).sort(tWeb['new_ts'],tWeb['count'].desc())


# In[18]:

#Add a new row that ranks URLs partitioned by months sorted by descreasing order of no. of clicks
rankedtWeb = sortedtWeb.select(sortedtWeb['new_ts'],sortedtWeb['u'],sortedtWeb['count'],F.rowNumber().over(Window.partitionBy(sortedtWeb['new_ts']).orderBy(sortedtWeb['count'].desc())).alias("RowNum"))


# In[19]:

#Exclude all records with rank > 11 since we only need top 10 for each month
topMonths = rankedtWeb.filter(rankedtWeb['RowNum'] < 11).sort(rankedtWeb['new_ts'],rankedtWeb['RowNum'])


# In[20]:

#Include only those columns that are needed in the output with proper aliasing
tm = topMonths.select(topMonths['new_ts'].alias("Month"), topMonths['u'].alias("URL") ,topMonths['count'])


# In[21]:

#Convert Spark dataframe to Pandas dataframe and export to a csv
tm.toPandas().to_csv('D:/INSOFE/Big Data/Project/TopWebsitesByMonth.csv', index=False)


I am not very sure but this might be the case since you are including all the attributes in your equation including 'crim' which was used to derive the 'TARGET' attribute (based on the median). Since all of the prediction is explained by this single attribute, it gives 100% accuracy which does not make any sense.

What I have done is exclude the 'crim' attribute from the regression equation and it seemed to have worked without any warning messages and gave a believable accuracy around 90%.
