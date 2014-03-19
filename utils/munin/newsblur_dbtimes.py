#!/usr/bin/env python 
from utils.munin.base import MuninGraph

class NBMuninGraph(MuninGraph):

    @property
    def graph_config(self):
        return {
            'graph_category' : 'NewsBlur',
            'graph_title' : 'NewsBlur DB Times',
            'graph_vlabel' : 'Database times (seconds)',
            'graph_args' : '-l 0',
            'sql_avg.label': 'SQL avg times (5m)',
            'mongo_avg.label': 'Mongo avg times (5m)',
            'redis_avg.label': 'Redis avg times (5m)',
        }

    def calculate_metrics(self):
        from apps.statistics.models import MStatistics
        
        return {
            'sql_avg': MStatistics.get('latest_sql_avg'),
            'mongo_avg': MStatistics.get('latest_mongo_avg'),
            'redis_avg': MStatistics.get('latest_redis_avg'),
        }

if __name__ == '__main__':
    NBMuninGraph().run()