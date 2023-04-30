package main

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"os"
	"time"
)

const (
	NO_OF_SUBJS              = 3
	NO_OF_QUESTIONS_PER_PAGE = 4
)

type AnswerScripts struct {
	Pages      uint8  `json:"pages"`
	AnswerKeys []byte `json:"answers"` // taking true false question paper
}

type Student struct {
	Name             string                     `json:"student_name"`
	Roll             int                        `json:"student_roll"`
	Marks            [NO_OF_SUBJS]float32       `json:"student_marks"`
	Learning         uint8                      `json:"student_study_time"`
	AssessmentPapers [NO_OF_SUBJS]AnswerScripts `json:"answerkeys"`
}

type Teacher struct {
	Name       string                     `json:"teacher_name"`
	EmpId      int                        `json:"teacher_empid"`
	AnswerKeys [NO_OF_SUBJS]AnswerScripts `json:"answerkeys"`
	Attandance map[string]bool            `json:"attandance"`
}

type StudentCollection struct {
	Students_info []Student `json:"students"`
}

type Students interface {
	TakeAssessment(int, uint)
}

type Teachers interface {
	GiveAssessment(int, int)
	TakeAttendance()
	GiveMarks(int, *StudentCollection)
}

func (stu *Student) Study() {
	const MAX_LEARNING_LIMIT = 60
	fmt.Println("[Learning] Started!")
	defer fmt.Println("[Learning] Done!")
	stu.Learning = uint8(rand.Intn(MAX_LEARNING_LIMIT))
}

func (stu *Student) TakeAssessment(subjIdx int, noOfQuestions int) {
	if subjIdx >= NO_OF_SUBJS {
		return
	}
	fmt.Println("[Assessment] Started!")
	defer fmt.Println("[Assessment] Done!")
	studentSpecificPaper := &stu.AssessmentPapers[subjIdx]

	studentSpecificPaper.Pages = uint8(rand.Intn(noOfQuestions / NO_OF_QUESTIONS_PER_PAGE))
	studentSpecificPaper.AnswerKeys = make([]byte, noOfQuestions)

	for i := 0; i < int(noOfQuestions); i++ {
		studentSpecificPaper.AnswerKeys[i] = byte(rand.Intn(2))
	}
}

func (teacher *Teacher) GiveAssessment(subjIdx, noOfQuestions int) {
	if subjIdx >= NO_OF_SUBJS {
		return
	}
	fmt.Println("[Assessment] Started!")
	defer fmt.Println("[Assessment] Done!")
	answers := &teacher.AnswerKeys[subjIdx]

	answers.Pages = uint8(rand.Intn(noOfQuestions / NO_OF_QUESTIONS_PER_PAGE))
	answers.AnswerKeys = make([]byte, noOfQuestions)

	for i := 0; i < int(noOfQuestions); i++ {
		answers.AnswerKeys[i] = byte(rand.Intn(2))
	}
}

func (teacher *Teacher) GiveMarks(subjID int, students *StudentCollection) {
	if subjID >= NO_OF_SUBJS {
		return
	}

	noOfQuestions := len(teacher.AnswerKeys[subjID].AnswerKeys)
	for questionIdx := 0; questionIdx < noOfQuestions; questionIdx++ {
		correctAnswer := teacher.AnswerKeys[subjID].AnswerKeys[questionIdx]

		for idx, s := range students.Students_info {
			if teacher.Attandance[s.Name] {
				studentAnswer := s.AssessmentPapers[subjID].AnswerKeys[questionIdx]
				if studentAnswer == correctAnswer {
					students.Students_info[idx].Marks[subjID] += 1
				}
			}
		}
	}
}

func GiveAttendance() bool {
	present := rand.Intn(2)
	if present == 1 {
		return true
	} else {
		return false
	}
}

func (teacher *Teacher) TakeAttendance(students StudentCollection) {
	teacher.Attandance = make(map[string]bool)
	for _, stu := range students.Students_info {
		teacher.Attandance[stu.Name] = GiveAttendance()
	}
}

func main() {
	rand.Seed(time.Now().UnixNano())
	n := -1
	fmt.Println("Enter the no of students.. ")
	fmt.Scanf("%d", &n)

	students := StudentCollection{}
	students.Students_info = make([]Student, n)

	fmt.Println("Its input time")
	for i := 0; i < n; i++ {
		student := Student{}
		fmt.Println("Enter the name")
		fmt.Scanf("%s", &student.Name)
		fmt.Println("Enter the roll")
		fmt.Scanf("%d", &student.Roll)
		students.Students_info[i] = student
	}

	teacher := &Teacher{EmpId: 23423432, Name: "Teacher DEmo"}

	var (
		subjectCode   = 0
		totalQuestion = 20
	)
	teacher.GiveAssessment(subjectCode, totalQuestion)

	////// teacher takes attandance //////
	teacher.TakeAttendance(students)

	for i := 0; i < n; i++ {
		s := &students.Students_info[i]
		s.Study()

		if teacher.Attandance[s.Name] {
			s.TakeAssessment(subjectCode, totalQuestion)
		}
	}

	teacher.GiveMarks(subjectCode, &students)

	bS, err := json.MarshalIndent(&students, "", "  ")
	if err != nil {
		panic(err)
	}

	bT, err := json.MarshalIndent(&teacher, "", "  ")
	if err != nil {
		panic(err)
	}
	if err := os.WriteFile("students.json", bS, 0755); err != nil {
		panic(err)
	}

	if err := os.WriteFile("teacher.json", bT, 0755); err != nil {
		panic(err)
	}

	fmt.Println("Saved data of teacher and students")
}
