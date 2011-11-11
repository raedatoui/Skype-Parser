class MessagesController < ApplicationController

  require 'open-uri'
    
  def index
    @conversation = Conversation.find_by_displayname("ym/global/")
    @messages = @conversation.messages #page(params[:page]).per(100)
    @messages.sort!{|a,b| b.timestamp <=> a.timestamp}
    @msg = Array.new
    @authors = Hash.new
    @urls = Array.new
    @hosts = Hash.new
    
    @youtubes = Array.new
    @vimeos = Hash.new
    @tumblrs = Array.new
    @images = Array.new
    
    re = /^(?:(?>[a-z0-9-]*\.)+?|)([a-z0-9-]+\.(?>[a-z]*(?>\.[a-z]{2})?))$/i
    @messages.each do |m|
      unless @authors.include?(m.author)
        @authors[m.author] =  1
      else
        @authors[m.author] +=  1
      end
      if(m && m.body_xml && m.body_xml.to_s.include?("<a href"))
        #puts URI.extract(m.body_xml)
        l = URI.extract(m.body_xml)[0]
        if l.include?("http")
          @msg.push(l)
          h = URI.parse(l).host
          domain = h.gsub(re, '\1').strip
          if domain == "youtube.com" || domain == "youtu.be"
            arr = l.split("v=")
            if arr && arr.length > 1
              if(arr[1].include?("&"))
                yid = arr[1].split("&")[0]
              else
                yid = arr[1]
              end
              @youtubes.push(yid)
              embed = '<iframe width="560" height="315" src="http://www.youtube.com/embed/'+yid+'" frameborder="0" allowfullscreen></iframe>'
            else
              #puts l
            end
          end
          
          if domain == "tumblr.com"
            arr = l.split("_")
            if arr.length == 3
              ext = arr[2].split(".")[1].to_s
              @tumblrs.push({"t" => arr[0].to_s + "_" + arr[1].to_s + "_100."+ext, "i" => l})
            
            end  
          end
          
          if domain == "vimeo.com"
            vid = l.split(".com/")[1]
            if vid.to_i.to_s == vid.to_s
              obj = JSON.parse(open("http://vimeo.com/api/v2/video/"+vid.to_s+".json").read)
              if obj[0]
                @vimeos[obj[0]["id"]] = {"thumb" => obj[0]["thumbnail_small"], "width" => obj[0]["width"], "height" => obj[0]["height"]}
              else
                puts obj.to_s
              end
            end    
          end
          
          if domain == "imgur.com"
            imgid = l.split(".com/")[1]
            ext = File.extname(l)
            if  ext != ''
              @images.push({"t" => "http://i.imgur.com/"+imgid.split(".")[0]+"s"+ext})
            else
              
            end
              
          end  

          unless @hosts.include?(domain)
            @hosts[domain] = 1
          else
            @hosts[domain] += 1
          end
        end
        #url =  parse_url(m.body_xml)
        #puts url.inspect
      end
    end
    @hosts = @hosts.sort_by{ |k,v| v }
    @authors = @authors.sort_by{ |k,v| v }
    #result = JSON.parse(open("http://gdata.youtube.com/feeds/api/videos/OYpwAtnywTkv=2&alt=json").read)
    #puts result.inspect
  end
  
  
  
  def parse_url(text)
  url_regexp = /http[s]?:\/\/\w/
  url = text.split.grep(url_regexp)
  
  #text.gsub(url,"<a href=\"" + url + "\" target=\"_blank\">" + url + "</a>").gsub("\n"," <br />")
  end  
  
  
  
  def show
     @message = Message.find(params[:id])
   end

   def new
     @message = Message.new
   end

   def create
     @message = Message.new(params[:product])
     if @message.save
       flash[:notice] = "Successfully created product."
       redirect_to @message
     else
       render :action => 'new'
     end
   end

   def edit
     @message = Message.find(params[:id])
   end

   def update
     @message = Message.find(params[:id])
     if @message.update_attributes(params[:product])
       flash[:notice] = "Successfully updated product."
       redirect_to @message
     else
       render :action => 'edit'
     end
   end

   def destroy
     @message = Message.find(params[:id])
     @message.destroy
     flash[:notice] = "Successfully destroyed product."
     redirect_to messagesu_url
   end
end
