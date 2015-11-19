DROP TABLE IF EXISTS MessagesUpdateLog;
CREATE TABLE IF NOT EXISTS MessagesUpdateLog (
  convo_id INTEGER,
  author TEXT,
  from_dispname TEXT,
  timestamp INTEGER,
  old_body_xml TEXT,
  new_body_xml TEXT
);
DROP TRIGGER IF EXISTS messages_update_trigger;

CREATE TRIGGER IF NOT EXISTS messages_update_trigger AFTER UPDATE OF body_xml ON Messages
  BEGIN
    INSERT INTO MessagesUpdateLog
    SELECT
      new.convo_id,
      new.author,
      new.from_dispname,
      new.timestamp,
      old.body_xml,
      new.body_xml

    WHERE (
      SELECT count(*) FROM MessagesUpdateLog
      WHERE timestamp = new.timestamp AND new_body_xml = new.body_xml
    ) = 0;
END;