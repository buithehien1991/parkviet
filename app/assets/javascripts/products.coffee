$(document).on 'turbolinks:load', ->
  return unless typeof(CKEDITOR) != undefined && typeof(CKEDITOR) != "undefined"

  for name of CKEDITOR.instances
    CKEDITOR.instances[name].destroy() if name?

  $('.ckeditor').each ->
    CKEDITOR.replace($(this).attr('id'))