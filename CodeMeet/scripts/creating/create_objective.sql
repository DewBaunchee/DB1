CREATE TABLE objective
(
    id          SERIAL,
    title       VARCHAR(40),
    description TEXT,
    template    TEXT,

    CONSTRAINT PK_objective PRIMARY KEY (id)
);
CLUSTER objective USING pk_objective;

CREATE TABLE solved_objective
(
    person_id                INT,
    objective_id             INT,
    programming_language_key VARCHAR(20),
    solving                  TEXT,

    CONSTRAINT FK_solved_objective_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_solved_objective_objective
        FOREIGN KEY (objective_id) REFERENCES objective (id)
            ON DELETE CASCADE ON UPDATE RESTRICT,

    CONSTRAINT FK_solved_objective_programming_language
        FOREIGN KEY (programming_language_key) REFERENCES programming_language (key)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE INDEX solved_objective_index ON solved_objective (person_id);
CLUSTER solved_objective USING solved_objective_index;