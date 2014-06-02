CREATE TABLE items (
  id serial PRIMARY KEY,
  item VARCHAR (250) NOT NULL,
  section_id integer NOT NULL
);

CREATE TABLE sections (
  id serial PRIMARY KEY,
  section VARCHAR (250) NOT NULL
);

CREATE TABLE lists (
  id serial PRIMARY KEY,
  items VARCHAR (5000) NOT NULL,
  created_at TIMESTAMP NOT NULL
);

INSERT INTO sections (section) VALUES ('meat');
INSERT INTO sections (section) VALUES ('bakery');
INSERT INTO sections (section) VALUES ('aisles');
INSERT INTO sections (section) VALUES ('other');

INSERT INTO items (item, section_id) VALUES ('bananas',1);
INSERT INTO items (item, section_id) VALUES ('blueberries',1);
INSERT INTO items (item, section_id) VALUES ('avocados',1);
INSERT INTO items (item, section_id) VALUES ('cabbage',1);
INSERT INTO items (item, section_id) VALUES ('coffee',6);
INSERT INTO items (item, section_id) VALUES ('eggs',2);
INSERT INTO items (item, section_id) VALUES ('yogurt',2);
INSERT INTO items (item, section_id) VALUES ('formula',5);
INSERT INTO items (item, section_id) VALUES ('baby oatmeal',5);
INSERT INTO items (item, section_id) VALUES ('peanut butter',5);
INSERT INTO items (item, section_id) VALUES ('chicken thighs',3);
INSERT INTO items (item, section_id) VALUES ('bacon',3);
INSERT INTO items (item, section_id) VALUES ('cheddar cheese',2);
INSERT INTO items (item, section_id) VALUES ('blue cheese',2);
INSERT INTO items (item, section_id) VALUES ('bread',4);
INSERT INTO items (item, section_id) VALUES ('milk',2);

ALTER TABLE items ALTER COLUMN section_id TYPE numeric(10,2);



