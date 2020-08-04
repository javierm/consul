if SiteCustomization::Page.find_by(slug: "privacy").nil?
  page = SiteCustomization::Page.new(slug: "privacy", status: "published")
  page.print_content_flag = true
  page.title = I18n.t("pages.privacy.title")
  page.subtitle = I18n.t("pages.privacy.subtitle")
  page.content = "
    <ol>
        <li>La navegación por la información disponible en el Portal de Gobierno Abierto es anónima.</li>
        <li>Para utilizar los servicios contenidos en el Portal de Gobierno Abierto el usuario deberá darse de alta y proporcionar previamente los datos de carácter personal segun la informacion especifica que consta en cada tipo de alta.</li>
        <li>Los datos aportados serán incorporados y tratados por el Gobierno de acuerdo con la descripción del fichero siguiente:</li>
        <ul>
            <li>
              <strong> Nombre del fichero/tratamiento:</strong>
              NOMBRE DEL FICHERO
            </li>
            <li>
              <strong> Finalidad del fichero/tratamiento:</strong>
              Gestionar los procesos participativos para el control de la habilitación de las personas que participan en los mismos y recuento meramente numérico y estadístico de los resultados derivados de los procesos de participación ciudadana.
            </li>
            <li>
              <strong> Órgano responsable:</strong>
              ÓRGANO RESPONSABLE
            </li>
        </ul>
        <li>El interesado podrá ejercer los derechos de acceso, rectificación, cancelación y oposición, ante el órgano responsable indicado todo lo cual se informa en el cumplimiento del artículo 5 de la Ley Orgánica 15/1999, de 13 de diciembre, de Protección de Datos de Carácter Personal.</li>
        <li>Como principio general, este sitio web no comparte ni revela información obtenida, excepto cuando haya sido autorizada por el usuario, o la informacion sea requerida por la autoridad judicial, ministerio fiscal o la policia judicial, o se de alguno de los supuestos regulados en el artículo 11 de la Ley Orgánica 15/1999, de 13 de diciembre, de Protección de Datos de Carácter Personal.</li>
  </ol>"
  page.save!
end
