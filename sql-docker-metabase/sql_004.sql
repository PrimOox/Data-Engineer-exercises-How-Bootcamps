from sqlalchemy import creat_engine
engine = creat_engine('postgresql+psycopg2://user:password@hostname/database_name')