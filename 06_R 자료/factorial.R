# # # # # factorial.R # # # # #

fact <- function(num){
  result <- 1 # 누적곱 변수
  if(num<0){
    cat('음수값을 위한 팩토리얼은 존재하지 않아요')
    # return ()
  }else if(num==0){
    cat('0! = 1')
    #return(1)
  } else {
    for(i in num:1){
      result = result * i
    }
    cat(num, '!=', result)
    #return(result)
  }
}