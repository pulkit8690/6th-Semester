import streamlit as st
import pandas as pd
import numpy as np
import plotly.express as px

st.title("Sentiment Analysis of Tweets about US Airlines")
st.sidebar.title("Sentiment Analysis of Tweets about US Airlines")

st.markdown("This Application is streamlit Dashboard to analyze the Sentiment Of Tweets ")
st.sidebar.markdown("This Application is streamlit Dashboard to analyze the Sentiment Of Tweets")

DATA_URL=("Tweets.csv")

@st.cache_data(persist=True)   

def load_data():
    data=pd.read_csv(DATA_URL)
    data['tweet_created']=pd.to_datetime(data['tweet_created'])
    return data

data=load_data()

#st.write(data)
st.sidebar.subheader("Show Random tweets")
random_tweet=st.sidebar.radio('Sentiment',('positive','neutral','negative'))
st.sidebar.markdown(data.query('airline_sentiment == @random_tweet')[["text"]].sample(n=1).iat[0,0])

st.sidebar.markdown("### Number of Tweets by Sentiment")
select=st.sidebar.selectbox('Visualization type',['Histogram','Pie Chart'],key='1')
sentiment_count=data['airline_sentiment'].value_counts()
sentiment_count=pd.DataFrame({'Sentiment':sentiment_count.index,'Tweets':sentiment_count.values})

if not st.sidebar.checkbox("Hide",True):
    st.markdown("### Number of Tweets by Sentiment")
    if select == "Histogram":
        fig=px.bar(sentiment_count,x='Sentiment',y='Tweets',color='Tweets',height=500)
        st.plotly_chart(fig)
    else:
        fig=px.pie(sentiment_count,values='Tweets',names='Sentiment')
        st.plotly_chart(fig)
        
        
# st.subheader("Sentiment Over Time")
# fig_time_series = px.scatter(data, x='tweet_created', y='airline_sentiment', color='airline_sentiment')
# st.plotly_chart(fig_time_series)

#st.map(data)
st.sidebar.subheader("When and Where are users tweeting From?")
hours=st.sidebar.number_input("Hour Of the Day", min_value=1,max_value=24)
hour=st.sidebar.slider("Hour of the Day",0,23)
modified_data=data[data['tweet_created'].dt.hour==hour]
if not st.sidebar.checkbox("Close",True,key='2'):
    st.markdown("### Tweets location based on time of the day")
    st.markdown("%i tweets between %i:00 and %i:00" %(len(modified_data),hour,(hour+1)%24))
    st.map(modified_data)
    

