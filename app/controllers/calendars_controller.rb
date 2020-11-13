class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week #指摘いただいた箇所
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
        params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # Date.today :2020-11-12
     # Date.today.day :12
      #Date.today.wday :4 
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)
         #whereで（）の中の条件を検索します。
    7.times do |x|
      today_plans = []
      plan = plans.map do |plan| #map = eachとほぼ同じ
        today_plans.push(plan.plan) if plan.date == @todays_date + x #今日の日付と@todays_date + xが一致している場合、予定をカラムに追加する
      end
      #wdayのバリューが7以上だと7を引く条件式
      wday_num = Date.today.wday + x
      if wday_num >= 7 
      # else
         wday_num = wday_num - 7
      end
      # もし、変数iが１０より大きければ、５引く　
      # if i > 9 
      #    i -= 5
      

      # day = days.map do |day|　
      #   today_days.push(day.day) if wday_num <= @todays_date + x 
      # end

      days = {month: (@todays_date + x).month, date: (@todays_date+x).day, plans: today_plans, wdays:wdays[wday_num] } #配列から要素を取り出す記述が必要:wdays[4]
      @week_days.push(days)
    end

  end
end
