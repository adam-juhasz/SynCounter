function B = meanImgFiltLSM(A)  %#codegen
  B = gpucoder.stencilKernel(@my_mean,A,[3 3],'same');
  
  function out = my_mean(A)
    out = cast(mean(A(:)), class(A));
  end
end