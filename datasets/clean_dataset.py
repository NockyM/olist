import pandas as pd
import csv

# lista = []
# lista.append ('datasets/olist_order_reviews_dataset.csv')
# lista.append ('datasets/olist_geolocation_dataset.csv')
# for i in lista:

# i = 'datasets/olist_order_reviews_dataset.csv'
# df = pd.read_csv(i, sep=',', index_col = False)
# df['review_comment_message'].replace('\n' ,'', regex=True, inplace = True)
# df['review_comment_message'].replace('\"' ,'', regex=True, inplace = True)
# df.to_csv(i, index = False)


i = 'datasets/olist_geolocation_dataset.csv'
df = pd.read_csv(i, sep=',', index_col = False)
df['geolocation_zip_code_prefix'].drop_duplicates()
df.to_excel(i + '.xlsx', index=False, engine='xlsxwriter')
df.to_csv(i, index = False)

    # df['review_comment_message'].replace('\' ,'', regex=True, inplace = True)
    # df['review_comment_message'].replace('\'' ,'', regex=True, inplace = True)
    # df['review_comment_message'] = "\"" + df['review_comment_message'] + "\""
    # df['review_comment_message'].replace('\"' ,'', regex=True, inplace = True)

    # df.to_excel(i + '.xlsx', index=False, engine='xlsxwriter')
    # df = pd.read_excel(i + '.xlsx')
    # df['review_comment_message'].replace('"','')
    # df['review_comment_message'] = '\"' + df['review_comment_message'] + '\"'