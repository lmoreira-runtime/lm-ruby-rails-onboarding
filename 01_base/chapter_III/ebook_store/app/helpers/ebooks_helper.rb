module EbooksHelper
  def ebook_status_badge(ebook)
    case ebook.status
    when 'draft'
      'bg-danger text-dark'
    when 'pending'
      'bg-warning text-dark'
    when 'live'
      'bg-success'
    end
  end
end
