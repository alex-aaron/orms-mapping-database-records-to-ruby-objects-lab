class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql =  <<-SQL
      SELECT * 
      FROM students
    SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql =  <<-SQL
      SELECT *
      FROM students 
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    ninth_students = []
    Student.all.each do |ind_student|
      if ind_student.grade == "9"
        ninth_students << ind_student
      end
    end
    ninth_students
  end

  def self.students_below_12th_grade
    not_12th_students = []
    Student.all.each do |ind_student|
      if ind_student.grade != "12"
        not_12th_students << ind_student
      end
    end
    not_12th_students
  end

  def self.first_X_students_in_grade_10(num_students)
    count = 0
    final_count = num_students
    first_num_students_array = []

    Student.all.each do |ind_student|
      if ind_student.grade == "10"
        first_num_students_array << ind_student
        count += 1
        if count == final_count
          return first_num_students_array
        end
      end
    end
  end

  def self.first_student_in_grade_10 
    Student.all.find do |ind_student|
      ind_student.grade == "10"
    end
  end

  def self.all_students_in_grade_X(grade)
    all_grade_array = []
    sorting_grade = grade.to_s
    Student.all.each do |ind_student|
      if ind_student.grade == sorting_grade
        all_grade_array << ind_student
      end
    end
    all_grade_array
  end

end
