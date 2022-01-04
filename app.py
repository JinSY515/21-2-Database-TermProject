import psycopg2
from flask import Flask, render_template, request, redirect,session, url_for, flash
app = Flask(__name__)
app.debug = True
conn = psycopg2.connect("dbname=project1 user=postgres password = ******" )
cur=conn.cursor()
app.secret_key = '1q2w3e4r'

@app.route('/')
def main():
    return render_template("main.html")

@app.route('/login', methods = ['GET', 'POST'])
def login():
    if request.method =='GET':
        return render_template("login.html")
    else:
        userid = request.form['userid']
        password = request.form['password']
        
        sql = 'SELECT * FROM users where id = \'' + userid + \
            ' \' and pwd = \'' + password + '\';'
        cur.execute(sql)
        result = cur.fetchall()
        if(result):
            session['userid'] = userid
            univ_sql = 'SELECT univ_name FROM university order by univ_id;'
            dp_sql = 'SELECT  univ_name,dept_name FROM department natural join university order by dept_id; '
            cur.execute(dp_sql)
            dp_result = cur.fetchall()
            cur.execute(univ_sql)
            univ_result = cur.fetchall()
            return render_template('subject.html', userid = session['userid'], dept_table = dp_result,univ_table = univ_result)
            
        else:
            return '존재하지 않는 정보입니다. 다시 로그인해주세요.'
        
@app.route('/logout', methods = ['GET'])
def logout():
    session.pop('userid', None)
    return redirect('/')

@app.route('/subject', methods = ['GET', 'POST'])
def subject():
    univ_sql = 'SELECT univ_name FROM university order by univ_id;'
    dp_sql = 'SELECT  univ_name,dept_name FROM department natural join university order by dept_id; '
    cur.execute(dp_sql)
    dp_result = cur.fetchall()
    cur.execute(univ_sql)
    univ_result = cur.fetchall()
    if request.method == 'GET':
        return render_template("subject.html", userid = session['userid'], dept_table = dp_result,univ_table = univ_result)
    else:
        dept = request.form['department']
        title = request.form['title']
        semester = request.form['semester_sel']
        year = request.form['year_fixed']
        is_major = request.form['major']
        if((dept != '학과명' and  dept!= None )and (title != '교과목명' and title !=None)):
            sql = 'with sem_year as (SELECT * FROM section WHERE semester = \'' + semester + '\' and year = \'' + year + '\' ) ' \
                  'SELECT * FROM courses natural join sem_year WHERE dept_name = \'' + dept + '\' and title like \'%'+title +'%\' and is_major = ' +is_major + ' order by course_id, sec_id ASC ;'
            cur.execute(sql)
        elif (dept != None and (title == '교과목명' or title == None)):
            sql = 'with sem_year as (SELECT * FROM section WHERE semester = %s and year = %s) ' \
                  'SELECT * FROM courses natural join sem_year WHERE dept_name = %s and is_major = ' +is_major + ' order by course_id, sec_id ASC;'
            val = (semester, year, dept)
            cur.execute(sql,val)
        elif ((dept =='학과명' or dept == None )and title):
            sql = 'with sem_year as (SELECT * FROM section WHERE semester = \'' + semester + '\' and year = \'' + year + '\') ' \
                  'SELECT * FROM courses natural join sem_year WHERE title like \'%'+title +'%\' and is_major = ' +is_major + ' order by course_id, sec_id ASC;'
            cur.execute(sql)
        else:
            return render_template("subject.html", userid = session['userid'])
        result = cur.fetchall()
        
        return render_template("subject.html", userid = session['userid'], subject= result, dept_table = dp_result,univ_table = univ_result)


@app.route('/course_register', methods = ['GET', 'POST'])
def course_register():
    userid = session['userid']
    if request.method =='GET':
        sql4 = 'SELECT R.course_id, R.sec_id, C.title, C.dept_name, C.credits, C.is_major, C.is_required, S.is_contact, S.is_not_contact, S.year, S.semester FROM registered as R, courses as C, section as S '\
        'WHERE R.course_id = C.course_id and C.course_id = S.course_id and R.sec_id = S.sec_id and R.semester = S.semester and R.year = S.year and id = \'' + userid + '\';'
        cur.execute(sql4)
        result4 = cur.fetchall()

        return render_template("course_register.html", userid = userid, subject_registered = result4)

    #먼저 초과학점인지 = 더 담을 수 있는지 확인.
    sql1 = 'SELECT id, sum(credits) FROM registered natural join courses  WHERE id = \'' + userid + '\' GROUP BY id;'
    cur.execute(sql1)
    result1 = cur.fetchall()
    

    course_id = request.form['course_id']
    sec_id = request.form['sec_id']
    semester = request.form['semester']
    year = request.form['year']
    credits = request.form['credits']

    if(year!= 2021 and semester != 'Fall'):
        return "등록 기간이 아닙니다!"
    if(result1):
        rows = [list(result1[x]) for x in range(len(result1))]
        if(rows[0][1] + int(credits) > 22):
            return "초과 학점입니다!"
        #이미 담겼는지 확인.

    sql = 'SELECT * FROM registered WHERE id = %s and course_id = %s and semester = %s and year = %s'
    val = (userid, course_id, semester, year)
    cur.execute(sql, val)
    result = cur.fetchall()
    if(result):
        return "이미 신청한 과목입니다!"
      
    sql2 = 'INSERT INTO registered (id, course_id, sec_id, semester, year) VALUES (%s, %s, %s, %s, %s)'
    val2 = (userid, course_id, sec_id, semester, year)

    cur.execute(sql2,val2)
    sql3 = 'UPDATE student SET tot_credit = tot_credit +' + credits + ' WHERE id = \'' + userid + '\';'
    cur.execute(sql3)
    conn.commit()
    sql4 = 'SELECT R.course_id, R.sec_id, C.title, C.dept_name, C.credits, C.is_major, C.is_required, S.is_contact, S.is_not_contact, S.year, S.semester FROM registered as R, courses as C, section as S '\
            'WHERE R.course_id = C.course_id and C.course_id = S.course_id and R.sec_id = S.sec_id and R.semester = S.semester and R.year = S.year and id = \'' + userid + '\';'
    cur.execute(sql4)
    result = cur.fetchall()
    return render_template("course_register.html", userid = userid, subject_registered = result)        


@app.route('/course_delete', methods = ['GET', 'POST'])
def course_delete():
    userid = session['userid']
    course_id = request.form['course_id']
    sec_id = request.form['sec_id']
    semester = request.form['semester']
    year = request.form['year']
    credits = request.form['credits']
    #과목신청이 되려면 무조건 semester, year 일정해야함. 
    sql = 'DELETE FROM registered WHERE course_id = %s and sec_id = %s and semester = %s and year = %s and id = %s;'
    val = (course_id, sec_id,semester, year, userid)
    cur.execute(sql,val)
    conn.commit()
    sql3 = 'UPDATE student SET tot_credit = tot_credit -' + credits + ' WHERE id = \'' + userid + '\';'
    cur.execute(sql3)
    conn.commit()

    return render_template("course_delete.html", userid = userid)

    

@app.route('/register', methods = ['GET', 'POST'])
def register():
    error = None
    if request.method =='GET':
        return render_template("register.html")
    else:
        userid = request.form.get('userid')
        password = request.form.get('password')
        re_password = request.form.get('re_password')

        
        if not (userid and password and re_password):
            return "채워지지 않은 부분이 있습니다. 확인해주세요"
        elif password != re_password:
            return "비밀번호가 맞지 않습니다. 확인해주세요."
        else:
            sql = 'SELECT s.id, s.name, u.id, u.pwd from student as s left outer join users as u on s.id = u.id WHERE s.id= \'' + userid + '\';'
            cur.execute(sql)
            result = cur.fetchall()
            if (result):
                row = [list(result[x]) for x in range(len(result))]
                if(row[0][3] is not None):
                    return "이미 있는 계정입니다."
                else:
                    mysql = 'INSERT INTO users (id, pwd) VALUES (%s, %s)'
                    val = (userid, password)
                    cur.execute(mysql, val)
                    conn.commit()
                    return redirect('/')
            else:
                return "존재하지 않는 학생 정보입니다."
            

if __name__ == '__main__':
    app.run(debug=True)
    conn.commit()