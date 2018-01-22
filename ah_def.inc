{$define iso_latin1}

{@/// Compiler switches for version checks}

// Quick-and-dirty work-around for new Delphi versions
{$ifdef fpc}     // Lazarus/FPC 
  {$define delphi_2007}
{$endif}
{$ifdef ver320}  // RAD Studio 10.2 Tokyo
  {$define delphi_2007}
{$endif}
{$ifdef ver310}  // RAD Studio 10.1 Berlin
  {$define delphi_2007}
{$endif}
{$ifdef ver300}  // RAD Studio 10.0 Seattle
  {$define delphi_2007}
{$endif}         
{$ifdef ver290}  // Delphi XE8
  {$define delphi_2007}
{$endif}
{$ifdef ver280}  // Delphi XE7
  {$define delphi_2007}
{$endif}
{$ifdef ver270}  // Delphi XE6
  {$define delphi_2007}
{$endif}
{$ifdef ver260}  // Delphi XE5
  {$define delphi_2007}
{$endif}
{$ifdef ver250}  // Delphi XE4
  {$define delphi_2007}
{$endif}
{$ifdef ver240}  // Delphi XE3
  {$define delphi_2007}
{$endif}
{$ifdef ver230}  // Delphi XE2
  {$define delphi_2007}
{$endif}
{$ifdef ver220}  // Delphi XE
  {$define delphi_2007}
{$endif}
{$ifdef ver210}  // Delphi 2010
  {$define delphi_2007}
{$endif}
{$ifdef ver200}  // Delphi 2009
  {$define delphi_2007}
{$endif}

// Old delphi versions
{$ifdef ver190}
  {$define delphi_2007}
{$else}
  {$ifdef ver180}
    {$define delphi_2006}
  {$else}
    {$ifdef ver170}
      {$define delphi_2005}
    {$else}
      {$ifdef ver160}
        {$define delphi_8}   { not used - can only do .NET}
      {$else}
        {$ifdef ver150}
          {$define delphi_7}
        {$else}
          {$ifdef ver140}
            {$define delphi_6}
          {$else}
            {$ifdef ver130}
              {$define delphi_5}
            {$else}
              {$ifdef ver120}
                {$define delphi_4}
              {$else}
                {$ifdef ver110}
                  {$define builder_3}
                {$else}
                  {$ifdef ver100}
                    {$define delphi_3}
                  {$else}
                    {$ifdef ver95}
                      {$define builder_1}
                    {$endif}
                    {$ifdef ver90}
                      {$define delphi_2}
                    {$else}
                      {$ifdef ver80}
                        {$define Delphi_1}
                      {$else}
                        {$define bp_7}
                      {$endif}
                    {$endif}
                  {$endif}
                {$endif}
              {$endif}
            {$endif}
          {$endif}
        {$endif}
      {$endif}
    {$endif}
  {$endif}
{$endif}

{$ifdef delphi_1}
  {$define delphi_ge_1}
{$endif}
{$ifdef delphi_2}
  {$define delphi_gt_1}
  {$define delphi_ge_1}
  {$define delphi_ge_2}
{$endif}
{$ifdef delphi_3}
  {$define delphi_gt_2}
  {$define delphi_gt_1}
  {$define delphi_ge_1}
  {$define delphi_ge_2}
  {$define delphi_ge_3}
{$endif }
{$ifdef delphi_4}
  {$define delphi_gt_3}
  {$define delphi_gt_2}
  {$define delphi_gt_1}
  {$define delphi_ge_1}
  {$define delphi_ge_2}
  {$define delphi_ge_3}
  {$define delphi_ge_4}
{$endif}
{$ifdef delphi_5}
  {$define delphi_gt_3}
  {$define delphi_gt_2}
  {$define delphi_gt_1}
  {$define delphi_ge_1}
  {$define delphi_ge_2}
  {$define delphi_ge_3}
  {$define delphi_ge_4}
  {$define delphi_ge_5}
{$endif}
{$ifdef delphi_6}
  {$define delphi_gt_5}
  {$define delphi_gt_4}
  {$define delphi_gt_3}
  {$define delphi_gt_2}
  {$define delphi_gt_1}
  {$define delphi_ge_1}
  {$define delphi_ge_2}
  {$define delphi_ge_3}
  {$define delphi_ge_4}
  {$define delphi_ge_5}
  {$define delphi_ge_6}
{$endif}
{$ifdef delphi_7}
  {$define delphi_gt_6}
  {$define delphi_gt_5}
  {$define delphi_gt_4}
  {$define delphi_gt_3}
  {$define delphi_gt_2}
  {$define delphi_gt_1}
  {$define delphi_ge_1}
  {$define delphi_ge_2}
  {$define delphi_ge_3}
  {$define delphi_ge_4}
  {$define delphi_ge_5}
  {$define delphi_ge_6}
  {$define delphi_ge_7}
{$endif}
{$ifdef delphi_2005}
  {$define delphi_gt_7}
  {$define delphi_gt_6}
  {$define delphi_gt_5}
  {$define delphi_gt_4}
  {$define delphi_gt_3}
  {$define delphi_gt_2}
  {$define delphi_gt_1}
  {$define delphi_ge_1}
  {$define delphi_ge_2}
  {$define delphi_ge_3}
  {$define delphi_ge_4}
  {$define delphi_ge_5}
  {$define delphi_ge_6}
  {$define delphi_ge_7}
  {$define delphi_ge_9}
{$endif}
{$ifdef delphi_2006}
  {$define delphi_gt_9}
  {$define delphi_gt_7}
  {$define delphi_gt_6}
  {$define delphi_gt_5}
  {$define delphi_gt_4}
  {$define delphi_gt_3}
  {$define delphi_gt_2}
  {$define delphi_gt_1}
  {$define delphi_ge_1}
  {$define delphi_ge_2}
  {$define delphi_ge_3}
  {$define delphi_ge_4}
  {$define delphi_ge_5}
  {$define delphi_ge_6}
  {$define delphi_ge_7}
  {$define delphi_ge_9}
  {$define delphi_ge_10}
{$endif}
{$ifdef delphi_2007}
  {$define delphi_gt_10}
  {$define delphi_gt_9}
  {$define delphi_gt_7}
  {$define delphi_gt_6}
  {$define delphi_gt_5}
  {$define delphi_gt_4}
  {$define delphi_gt_3}
  {$define delphi_gt_2}
  {$define delphi_gt_1}
  {$define delphi_ge_1}
  {$define delphi_ge_2}
  {$define delphi_ge_3}
  {$define delphi_ge_4}
  {$define delphi_ge_5}
  {$define delphi_ge_6}
  {$define delphi_ge_7}
  {$define delphi_ge_9}
  {$define delphi_ge_10}
  {$define delphi_ge_11}
{$endif}


{ shortstring defined  :  use string in VCL methods }
{             undefined:  use ansistring instead    }

{$ifdef delphi_1}
  {$define shortstring}
{$else }
  { The Delphi2/3 VCL only compiles with huge strings }
  {$undef shortstring}
  {$define support_warnings}
{$endif}
{@\\\}
