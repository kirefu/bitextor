#!/usr/bin/env python3

import os
import sys
import argparse
import mysql.connector

######################################################################################
def GetChildren(mycursor, child, parent):
    sql = "select link.document_id as parent_doc from link, url where link.url_id = url.id and url.document_id = %s"
    val =(docId, )
    mycursor.execute(sql, val)
    res = mycursor.fetchall()
    #print("  res", len(res))

    for row in res:
        print("  row", row)

######################################################################################

def Main():
    print("Starting")

    mydb = mysql.connector.connect(
        host="localhost",
        user="paracrawl_user",
        passwd="paracrawl_password",
        database="paracrawl",
        charset='utf8'
    )
    mydb.autocommit = False
    mycursor = mydb.cursor(buffered=True)

    sql = "select url.document_id as child, link.document_id as parent" \
        + " from link, url, document_align" \
        + " where link.url_id = url.id" \
        + " and url.document_id = document_align.document1" \
        + " order by child"

    mycursor.execute(sql)
    res = mycursor.fetchall()
    print("res", len(res))

    for row in res:
        print("row", row)
        child = row[0]
        parent = row[1]
        parents = GetChildren(mycursor, child, parent)

    print("Finished")

if __name__ == "__main__":
    Main()

