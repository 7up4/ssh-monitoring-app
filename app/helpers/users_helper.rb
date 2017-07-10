module UsersHelper
  def user_fio(fn,ln,sn)
    if [fn, ln, sn].all?(&:present?)
      return "#{ln} #{fn[0]}. #{sn[0]}."
    else
      return "#{ln} #{fn}"
    end
  end
end
