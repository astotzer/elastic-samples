#!/usr/bin/env bash

echo create index 'breweries'
curl -XPUT 'http://localhost:9200/breweries/'

echo
echo add type 'brewery'
curl -XPUT 'http://localhost:9200/breweries/_mapping/brewery' -d '
{
    "brewery": {
        "dynamic": "strict",
        "properties": {
            "name": {"type": "string"},
            "phone": {"type": "string", "index": "no"},
            "email": {"type": "string"},
            "homepage": {"type": "string"},
            "street": {"type": "string"},
            "city": {"type": "string"},
            "zip": {"type": "integer", "index": "not_analyzed"},
            "state": {"type": "string"},
            "location": {"type": "geo_point"},
            "registered": {"type": "date", "format": "YYYY-MM-dd"},
            "specialities": {
                "properties": {
                    "type": {"type": "string", "index": "not_analyzed"},
                    "blend": {"type": "string"},
                    "strength": {"type": "float"}
                }
            }
        }
    }
}'

echo
echo index breweries
cat breweries.json | jq -c '.data[] | {"index": {"_index": "breweries", "_type": "brewery", "_id": .id}}, .' | curl -XPOST localhost:9200/_bulk --data-binary @-

echo
echo done