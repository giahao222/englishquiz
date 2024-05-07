class ResultItem {
  List<String> ques;
  List<String> ans;
  List<String> des;
  List<String> quesafter;
  List<String> answer;
  List<bool> result;

  ResultItem(
      this.ques, this.ans, this.des, this.quesafter, this.answer, this.result);

  List<String> getAnswer() {
    return answer;
  }

  void setAnswer(List<String> answer) {
    this.answer = answer;
  }

  List<String> getQues() {
    return ques;
  }

  void setQues(List<String> ques) {
    this.ques = ques;
  }

  List<String> getAns() {
    return ans;
  }

  void setAns(List<String> ans) {
    this.ans = ans;
  }

  List<String> getDes() {
    return des;
  }

  void setDes(List<String> des) {
    this.des = des;
  }

  List<String> getQuesafter() {
    return quesafter;
  }

  void setQuesafter(List<String> quesafter) {
    this.quesafter = quesafter;
  }

  List<bool> getResult() {
    return result;
  }

  void setResult(List<bool> result) {
    this.result = result;
  }
}
