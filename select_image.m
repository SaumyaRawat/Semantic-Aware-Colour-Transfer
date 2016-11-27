function[index]=select_image(k,options,I)
  hfig=figure;
  for i=1:k
    subplot(2,2,i);
    im = imread(['dataset/image/',I(options(i)).name]);
    h{i}.h = imshow(im);
    set(h{i}.h, 'buttondownfcn', {@loads_of_stuff,i});
  end

  function loads_of_stuff(src,eventdata,x)
    if get(src,'UserData')
        set(src,'UserData',0)
        title('');
    else
        set(src,'UserData',1)
        title('Selected');
        %[filename,user_canc]=imsave(src);
        %image=imread(filename);
    end
    fprintf('%s:\n',num2str(x));
    index = x;
  end
uiwait(hfig);
end
