
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Sheets
## version: v4
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Reads and writes Google Sheets.
## 
## https://developers.google.com/sheets/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_579373 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579373](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579373): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "sheets"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SheetsSpreadsheetsCreate_579644 = ref object of OpenApiRestCall_579373
proc url_SheetsSpreadsheetsCreate_579646(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_SheetsSpreadsheetsCreate_579645(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a spreadsheet, returning the newly created spreadsheet.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579758 = query.getOrDefault("key")
  valid_579758 = validateParameter(valid_579758, JString, required = false,
                                 default = nil)
  if valid_579758 != nil:
    section.add "key", valid_579758
  var valid_579772 = query.getOrDefault("prettyPrint")
  valid_579772 = validateParameter(valid_579772, JBool, required = false,
                                 default = newJBool(true))
  if valid_579772 != nil:
    section.add "prettyPrint", valid_579772
  var valid_579773 = query.getOrDefault("oauth_token")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "oauth_token", valid_579773
  var valid_579774 = query.getOrDefault("$.xgafv")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = newJString("1"))
  if valid_579774 != nil:
    section.add "$.xgafv", valid_579774
  var valid_579775 = query.getOrDefault("alt")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = newJString("json"))
  if valid_579775 != nil:
    section.add "alt", valid_579775
  var valid_579776 = query.getOrDefault("uploadType")
  valid_579776 = validateParameter(valid_579776, JString, required = false,
                                 default = nil)
  if valid_579776 != nil:
    section.add "uploadType", valid_579776
  var valid_579777 = query.getOrDefault("quotaUser")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = nil)
  if valid_579777 != nil:
    section.add "quotaUser", valid_579777
  var valid_579778 = query.getOrDefault("callback")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "callback", valid_579778
  var valid_579779 = query.getOrDefault("fields")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "fields", valid_579779
  var valid_579780 = query.getOrDefault("access_token")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = nil)
  if valid_579780 != nil:
    section.add "access_token", valid_579780
  var valid_579781 = query.getOrDefault("upload_protocol")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = nil)
  if valid_579781 != nil:
    section.add "upload_protocol", valid_579781
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579805: Call_SheetsSpreadsheetsCreate_579644; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a spreadsheet, returning the newly created spreadsheet.
  ## 
  let valid = call_579805.validator(path, query, header, formData, body)
  let scheme = call_579805.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579805.url(scheme.get, call_579805.host, call_579805.base,
                         call_579805.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579805, url, valid)

proc call*(call_579876: Call_SheetsSpreadsheetsCreate_579644; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsCreate
  ## Creates a spreadsheet, returning the newly created spreadsheet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579877 = newJObject()
  var body_579879 = newJObject()
  add(query_579877, "key", newJString(key))
  add(query_579877, "prettyPrint", newJBool(prettyPrint))
  add(query_579877, "oauth_token", newJString(oauthToken))
  add(query_579877, "$.xgafv", newJString(Xgafv))
  add(query_579877, "alt", newJString(alt))
  add(query_579877, "uploadType", newJString(uploadType))
  add(query_579877, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579879 = body
  add(query_579877, "callback", newJString(callback))
  add(query_579877, "fields", newJString(fields))
  add(query_579877, "access_token", newJString(accessToken))
  add(query_579877, "upload_protocol", newJString(uploadProtocol))
  result = call_579876.call(nil, query_579877, nil, nil, body_579879)

var sheetsSpreadsheetsCreate* = Call_SheetsSpreadsheetsCreate_579644(
    name: "sheetsSpreadsheetsCreate", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com", route: "/v4/spreadsheets",
    validator: validate_SheetsSpreadsheetsCreate_579645, base: "/",
    url: url_SheetsSpreadsheetsCreate_579646, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsGet_579918 = ref object of OpenApiRestCall_579373
proc url_SheetsSpreadsheetsGet_579920(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsGet_579919(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the spreadsheet at the given ID.
  ## The caller must specify the spreadsheet ID.
  ## 
  ## By default, data within grids will not be returned.
  ## You can include grid data one of two ways:
  ## 
  ## * Specify a field mask listing your desired fields using the `fields` URL
  ## parameter in HTTP
  ## 
  ## * Set the includeGridData
  ## URL parameter to true.  If a field mask is set, the `includeGridData`
  ## parameter is ignored
  ## 
  ## For large spreadsheets, it is recommended to retrieve only the specific
  ## fields of the spreadsheet that you want.
  ## 
  ## To retrieve only subsets of the spreadsheet, use the
  ## ranges URL parameter.
  ## Multiple ranges can be specified.  Limiting the range will
  ## return only the portions of the spreadsheet that intersect the requested
  ## ranges. Ranges are specified using A1 notation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The spreadsheet to request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_579935 = path.getOrDefault("spreadsheetId")
  valid_579935 = validateParameter(valid_579935, JString, required = true,
                                 default = nil)
  if valid_579935 != nil:
    section.add "spreadsheetId", valid_579935
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ranges: JArray
  ##         : The ranges to retrieve from the spreadsheet.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   includeGridData: JBool
  ##                  : True if grid data should be returned.
  ## This parameter is ignored if a field mask was set in the request.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579936 = query.getOrDefault("key")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "key", valid_579936
  var valid_579937 = query.getOrDefault("ranges")
  valid_579937 = validateParameter(valid_579937, JArray, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "ranges", valid_579937
  var valid_579938 = query.getOrDefault("prettyPrint")
  valid_579938 = validateParameter(valid_579938, JBool, required = false,
                                 default = newJBool(true))
  if valid_579938 != nil:
    section.add "prettyPrint", valid_579938
  var valid_579939 = query.getOrDefault("oauth_token")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = nil)
  if valid_579939 != nil:
    section.add "oauth_token", valid_579939
  var valid_579940 = query.getOrDefault("includeGridData")
  valid_579940 = validateParameter(valid_579940, JBool, required = false, default = nil)
  if valid_579940 != nil:
    section.add "includeGridData", valid_579940
  var valid_579941 = query.getOrDefault("$.xgafv")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = newJString("1"))
  if valid_579941 != nil:
    section.add "$.xgafv", valid_579941
  var valid_579942 = query.getOrDefault("alt")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = newJString("json"))
  if valid_579942 != nil:
    section.add "alt", valid_579942
  var valid_579943 = query.getOrDefault("uploadType")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "uploadType", valid_579943
  var valid_579944 = query.getOrDefault("quotaUser")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "quotaUser", valid_579944
  var valid_579945 = query.getOrDefault("callback")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "callback", valid_579945
  var valid_579946 = query.getOrDefault("fields")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "fields", valid_579946
  var valid_579947 = query.getOrDefault("access_token")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "access_token", valid_579947
  var valid_579948 = query.getOrDefault("upload_protocol")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "upload_protocol", valid_579948
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579949: Call_SheetsSpreadsheetsGet_579918; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the spreadsheet at the given ID.
  ## The caller must specify the spreadsheet ID.
  ## 
  ## By default, data within grids will not be returned.
  ## You can include grid data one of two ways:
  ## 
  ## * Specify a field mask listing your desired fields using the `fields` URL
  ## parameter in HTTP
  ## 
  ## * Set the includeGridData
  ## URL parameter to true.  If a field mask is set, the `includeGridData`
  ## parameter is ignored
  ## 
  ## For large spreadsheets, it is recommended to retrieve only the specific
  ## fields of the spreadsheet that you want.
  ## 
  ## To retrieve only subsets of the spreadsheet, use the
  ## ranges URL parameter.
  ## Multiple ranges can be specified.  Limiting the range will
  ## return only the portions of the spreadsheet that intersect the requested
  ## ranges. Ranges are specified using A1 notation.
  ## 
  let valid = call_579949.validator(path, query, header, formData, body)
  let scheme = call_579949.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579949.url(scheme.get, call_579949.host, call_579949.base,
                         call_579949.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579949, url, valid)

proc call*(call_579950: Call_SheetsSpreadsheetsGet_579918; spreadsheetId: string;
          key: string = ""; ranges: JsonNode = nil; prettyPrint: bool = true;
          oauthToken: string = ""; includeGridData: bool = false; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsGet
  ## Returns the spreadsheet at the given ID.
  ## The caller must specify the spreadsheet ID.
  ## 
  ## By default, data within grids will not be returned.
  ## You can include grid data one of two ways:
  ## 
  ## * Specify a field mask listing your desired fields using the `fields` URL
  ## parameter in HTTP
  ## 
  ## * Set the includeGridData
  ## URL parameter to true.  If a field mask is set, the `includeGridData`
  ## parameter is ignored
  ## 
  ## For large spreadsheets, it is recommended to retrieve only the specific
  ## fields of the spreadsheet that you want.
  ## 
  ## To retrieve only subsets of the spreadsheet, use the
  ## ranges URL parameter.
  ## Multiple ranges can be specified.  Limiting the range will
  ## return only the portions of the spreadsheet that intersect the requested
  ## ranges. Ranges are specified using A1 notation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ranges: JArray
  ##         : The ranges to retrieve from the spreadsheet.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   includeGridData: bool
  ##                  : True if grid data should be returned.
  ## This parameter is ignored if a field mask was set in the request.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The spreadsheet to request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579951 = newJObject()
  var query_579952 = newJObject()
  add(query_579952, "key", newJString(key))
  if ranges != nil:
    query_579952.add "ranges", ranges
  add(query_579952, "prettyPrint", newJBool(prettyPrint))
  add(query_579952, "oauth_token", newJString(oauthToken))
  add(query_579952, "includeGridData", newJBool(includeGridData))
  add(query_579952, "$.xgafv", newJString(Xgafv))
  add(query_579952, "alt", newJString(alt))
  add(query_579952, "uploadType", newJString(uploadType))
  add(query_579952, "quotaUser", newJString(quotaUser))
  add(query_579952, "callback", newJString(callback))
  add(path_579951, "spreadsheetId", newJString(spreadsheetId))
  add(query_579952, "fields", newJString(fields))
  add(query_579952, "access_token", newJString(accessToken))
  add(query_579952, "upload_protocol", newJString(uploadProtocol))
  result = call_579950.call(path_579951, query_579952, nil, nil, nil)

var sheetsSpreadsheetsGet* = Call_SheetsSpreadsheetsGet_579918(
    name: "sheetsSpreadsheetsGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com", route: "/v4/spreadsheets/{spreadsheetId}",
    validator: validate_SheetsSpreadsheetsGet_579919, base: "/",
    url: url_SheetsSpreadsheetsGet_579920, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsDeveloperMetadataGet_579953 = ref object of OpenApiRestCall_579373
proc url_SheetsSpreadsheetsDeveloperMetadataGet_579955(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  assert "metadataId" in path, "`metadataId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/developerMetadata/"),
               (kind: VariableSegment, value: "metadataId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsDeveloperMetadataGet_579954(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the developer metadata with the specified ID.
  ## The caller must specify the spreadsheet ID and the developer metadata's
  ## unique metadataId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   metadataId: JInt (required)
  ##             : The ID of the developer metadata to retrieve.
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to retrieve metadata from.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `metadataId` field"
  var valid_579956 = path.getOrDefault("metadataId")
  valid_579956 = validateParameter(valid_579956, JInt, required = true, default = nil)
  if valid_579956 != nil:
    section.add "metadataId", valid_579956
  var valid_579957 = path.getOrDefault("spreadsheetId")
  valid_579957 = validateParameter(valid_579957, JString, required = true,
                                 default = nil)
  if valid_579957 != nil:
    section.add "spreadsheetId", valid_579957
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579958 = query.getOrDefault("key")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "key", valid_579958
  var valid_579959 = query.getOrDefault("prettyPrint")
  valid_579959 = validateParameter(valid_579959, JBool, required = false,
                                 default = newJBool(true))
  if valid_579959 != nil:
    section.add "prettyPrint", valid_579959
  var valid_579960 = query.getOrDefault("oauth_token")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "oauth_token", valid_579960
  var valid_579961 = query.getOrDefault("$.xgafv")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = newJString("1"))
  if valid_579961 != nil:
    section.add "$.xgafv", valid_579961
  var valid_579962 = query.getOrDefault("alt")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = newJString("json"))
  if valid_579962 != nil:
    section.add "alt", valid_579962
  var valid_579963 = query.getOrDefault("uploadType")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "uploadType", valid_579963
  var valid_579964 = query.getOrDefault("quotaUser")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "quotaUser", valid_579964
  var valid_579965 = query.getOrDefault("callback")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "callback", valid_579965
  var valid_579966 = query.getOrDefault("fields")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "fields", valid_579966
  var valid_579967 = query.getOrDefault("access_token")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "access_token", valid_579967
  var valid_579968 = query.getOrDefault("upload_protocol")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "upload_protocol", valid_579968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579969: Call_SheetsSpreadsheetsDeveloperMetadataGet_579953;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the developer metadata with the specified ID.
  ## The caller must specify the spreadsheet ID and the developer metadata's
  ## unique metadataId.
  ## 
  let valid = call_579969.validator(path, query, header, formData, body)
  let scheme = call_579969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579969.url(scheme.get, call_579969.host, call_579969.base,
                         call_579969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579969, url, valid)

proc call*(call_579970: Call_SheetsSpreadsheetsDeveloperMetadataGet_579953;
          metadataId: int; spreadsheetId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsDeveloperMetadataGet
  ## Returns the developer metadata with the specified ID.
  ## The caller must specify the spreadsheet ID and the developer metadata's
  ## unique metadataId.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   metadataId: int (required)
  ##             : The ID of the developer metadata to retrieve.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve metadata from.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579971 = newJObject()
  var query_579972 = newJObject()
  add(query_579972, "key", newJString(key))
  add(query_579972, "prettyPrint", newJBool(prettyPrint))
  add(query_579972, "oauth_token", newJString(oauthToken))
  add(query_579972, "$.xgafv", newJString(Xgafv))
  add(path_579971, "metadataId", newJInt(metadataId))
  add(query_579972, "alt", newJString(alt))
  add(query_579972, "uploadType", newJString(uploadType))
  add(query_579972, "quotaUser", newJString(quotaUser))
  add(query_579972, "callback", newJString(callback))
  add(path_579971, "spreadsheetId", newJString(spreadsheetId))
  add(query_579972, "fields", newJString(fields))
  add(query_579972, "access_token", newJString(accessToken))
  add(query_579972, "upload_protocol", newJString(uploadProtocol))
  result = call_579970.call(path_579971, query_579972, nil, nil, nil)

var sheetsSpreadsheetsDeveloperMetadataGet* = Call_SheetsSpreadsheetsDeveloperMetadataGet_579953(
    name: "sheetsSpreadsheetsDeveloperMetadataGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/developerMetadata/{metadataId}",
    validator: validate_SheetsSpreadsheetsDeveloperMetadataGet_579954, base: "/",
    url: url_SheetsSpreadsheetsDeveloperMetadataGet_579955,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsDeveloperMetadataSearch_579973 = ref object of OpenApiRestCall_579373
proc url_SheetsSpreadsheetsDeveloperMetadataSearch_579975(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/developerMetadata:search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsDeveloperMetadataSearch_579974(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all developer metadata matching the specified DataFilter.
  ## If the provided DataFilter represents a DeveloperMetadataLookup object,
  ## this will return all DeveloperMetadata entries selected by it. If the
  ## DataFilter represents a location in a spreadsheet, this will return all
  ## developer metadata associated with locations intersecting that region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to retrieve metadata from.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_579976 = path.getOrDefault("spreadsheetId")
  valid_579976 = validateParameter(valid_579976, JString, required = true,
                                 default = nil)
  if valid_579976 != nil:
    section.add "spreadsheetId", valid_579976
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579977 = query.getOrDefault("key")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "key", valid_579977
  var valid_579978 = query.getOrDefault("prettyPrint")
  valid_579978 = validateParameter(valid_579978, JBool, required = false,
                                 default = newJBool(true))
  if valid_579978 != nil:
    section.add "prettyPrint", valid_579978
  var valid_579979 = query.getOrDefault("oauth_token")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "oauth_token", valid_579979
  var valid_579980 = query.getOrDefault("$.xgafv")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = newJString("1"))
  if valid_579980 != nil:
    section.add "$.xgafv", valid_579980
  var valid_579981 = query.getOrDefault("alt")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = newJString("json"))
  if valid_579981 != nil:
    section.add "alt", valid_579981
  var valid_579982 = query.getOrDefault("uploadType")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "uploadType", valid_579982
  var valid_579983 = query.getOrDefault("quotaUser")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "quotaUser", valid_579983
  var valid_579984 = query.getOrDefault("callback")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "callback", valid_579984
  var valid_579985 = query.getOrDefault("fields")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "fields", valid_579985
  var valid_579986 = query.getOrDefault("access_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "access_token", valid_579986
  var valid_579987 = query.getOrDefault("upload_protocol")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "upload_protocol", valid_579987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579989: Call_SheetsSpreadsheetsDeveloperMetadataSearch_579973;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all developer metadata matching the specified DataFilter.
  ## If the provided DataFilter represents a DeveloperMetadataLookup object,
  ## this will return all DeveloperMetadata entries selected by it. If the
  ## DataFilter represents a location in a spreadsheet, this will return all
  ## developer metadata associated with locations intersecting that region.
  ## 
  let valid = call_579989.validator(path, query, header, formData, body)
  let scheme = call_579989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579989.url(scheme.get, call_579989.host, call_579989.base,
                         call_579989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579989, url, valid)

proc call*(call_579990: Call_SheetsSpreadsheetsDeveloperMetadataSearch_579973;
          spreadsheetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsDeveloperMetadataSearch
  ## Returns all developer metadata matching the specified DataFilter.
  ## If the provided DataFilter represents a DeveloperMetadataLookup object,
  ## this will return all DeveloperMetadata entries selected by it. If the
  ## DataFilter represents a location in a spreadsheet, this will return all
  ## developer metadata associated with locations intersecting that region.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve metadata from.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579991 = newJObject()
  var query_579992 = newJObject()
  var body_579993 = newJObject()
  add(query_579992, "key", newJString(key))
  add(query_579992, "prettyPrint", newJBool(prettyPrint))
  add(query_579992, "oauth_token", newJString(oauthToken))
  add(query_579992, "$.xgafv", newJString(Xgafv))
  add(query_579992, "alt", newJString(alt))
  add(query_579992, "uploadType", newJString(uploadType))
  add(query_579992, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579993 = body
  add(query_579992, "callback", newJString(callback))
  add(path_579991, "spreadsheetId", newJString(spreadsheetId))
  add(query_579992, "fields", newJString(fields))
  add(query_579992, "access_token", newJString(accessToken))
  add(query_579992, "upload_protocol", newJString(uploadProtocol))
  result = call_579990.call(path_579991, query_579992, nil, nil, body_579993)

var sheetsSpreadsheetsDeveloperMetadataSearch* = Call_SheetsSpreadsheetsDeveloperMetadataSearch_579973(
    name: "sheetsSpreadsheetsDeveloperMetadataSearch", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/developerMetadata:search",
    validator: validate_SheetsSpreadsheetsDeveloperMetadataSearch_579974,
    base: "/", url: url_SheetsSpreadsheetsDeveloperMetadataSearch_579975,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsSheetsCopyTo_579994 = ref object of OpenApiRestCall_579373
proc url_SheetsSpreadsheetsSheetsCopyTo_579996(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  assert "sheetId" in path, "`sheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/sheets/"),
               (kind: VariableSegment, value: "sheetId"),
               (kind: ConstantSegment, value: ":copyTo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsSheetsCopyTo_579995(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Copies a single sheet from a spreadsheet to another spreadsheet.
  ## Returns the properties of the newly created sheet.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sheetId: JInt (required)
  ##          : The ID of the sheet to copy.
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet containing the sheet to copy.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sheetId` field"
  var valid_579997 = path.getOrDefault("sheetId")
  valid_579997 = validateParameter(valid_579997, JInt, required = true, default = nil)
  if valid_579997 != nil:
    section.add "sheetId", valid_579997
  var valid_579998 = path.getOrDefault("spreadsheetId")
  valid_579998 = validateParameter(valid_579998, JString, required = true,
                                 default = nil)
  if valid_579998 != nil:
    section.add "spreadsheetId", valid_579998
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579999 = query.getOrDefault("key")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "key", valid_579999
  var valid_580000 = query.getOrDefault("prettyPrint")
  valid_580000 = validateParameter(valid_580000, JBool, required = false,
                                 default = newJBool(true))
  if valid_580000 != nil:
    section.add "prettyPrint", valid_580000
  var valid_580001 = query.getOrDefault("oauth_token")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "oauth_token", valid_580001
  var valid_580002 = query.getOrDefault("$.xgafv")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = newJString("1"))
  if valid_580002 != nil:
    section.add "$.xgafv", valid_580002
  var valid_580003 = query.getOrDefault("alt")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = newJString("json"))
  if valid_580003 != nil:
    section.add "alt", valid_580003
  var valid_580004 = query.getOrDefault("uploadType")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "uploadType", valid_580004
  var valid_580005 = query.getOrDefault("quotaUser")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "quotaUser", valid_580005
  var valid_580006 = query.getOrDefault("callback")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "callback", valid_580006
  var valid_580007 = query.getOrDefault("fields")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "fields", valid_580007
  var valid_580008 = query.getOrDefault("access_token")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "access_token", valid_580008
  var valid_580009 = query.getOrDefault("upload_protocol")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "upload_protocol", valid_580009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580011: Call_SheetsSpreadsheetsSheetsCopyTo_579994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies a single sheet from a spreadsheet to another spreadsheet.
  ## Returns the properties of the newly created sheet.
  ## 
  let valid = call_580011.validator(path, query, header, formData, body)
  let scheme = call_580011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580011.url(scheme.get, call_580011.host, call_580011.base,
                         call_580011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580011, url, valid)

proc call*(call_580012: Call_SheetsSpreadsheetsSheetsCopyTo_579994; sheetId: int;
          spreadsheetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsSheetsCopyTo
  ## Copies a single sheet from a spreadsheet to another spreadsheet.
  ## Returns the properties of the newly created sheet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   sheetId: int (required)
  ##          : The ID of the sheet to copy.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet containing the sheet to copy.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580013 = newJObject()
  var query_580014 = newJObject()
  var body_580015 = newJObject()
  add(query_580014, "key", newJString(key))
  add(query_580014, "prettyPrint", newJBool(prettyPrint))
  add(query_580014, "oauth_token", newJString(oauthToken))
  add(path_580013, "sheetId", newJInt(sheetId))
  add(query_580014, "$.xgafv", newJString(Xgafv))
  add(query_580014, "alt", newJString(alt))
  add(query_580014, "uploadType", newJString(uploadType))
  add(query_580014, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580015 = body
  add(query_580014, "callback", newJString(callback))
  add(path_580013, "spreadsheetId", newJString(spreadsheetId))
  add(query_580014, "fields", newJString(fields))
  add(query_580014, "access_token", newJString(accessToken))
  add(query_580014, "upload_protocol", newJString(uploadProtocol))
  result = call_580012.call(path_580013, query_580014, nil, nil, body_580015)

var sheetsSpreadsheetsSheetsCopyTo* = Call_SheetsSpreadsheetsSheetsCopyTo_579994(
    name: "sheetsSpreadsheetsSheetsCopyTo", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/sheets/{sheetId}:copyTo",
    validator: validate_SheetsSpreadsheetsSheetsCopyTo_579995, base: "/",
    url: url_SheetsSpreadsheetsSheetsCopyTo_579996, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesUpdate_580039 = ref object of OpenApiRestCall_579373
proc url_SheetsSpreadsheetsValuesUpdate_580041(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  assert "range" in path, "`range` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/values/"),
               (kind: VariableSegment, value: "range")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesUpdate_580040(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets values in a range of a spreadsheet.
  ## The caller must specify the spreadsheet ID, range, and
  ## a valueInputOption.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to update.
  ##   range: JString (required)
  ##        : The A1 notation of the values to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_580042 = path.getOrDefault("spreadsheetId")
  valid_580042 = validateParameter(valid_580042, JString, required = true,
                                 default = nil)
  if valid_580042 != nil:
    section.add "spreadsheetId", valid_580042
  var valid_580043 = path.getOrDefault("range")
  valid_580043 = validateParameter(valid_580043, JString, required = true,
                                 default = nil)
  if valid_580043 != nil:
    section.add "range", valid_580043
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   responseValueRenderOption: JString
  ##                            : Determines how values in the response should be rendered.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   responseDateTimeRenderOption: JString
  ##                               : Determines how dates, times, and durations in the response should be
  ## rendered. This is ignored if response_value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is
  ## DateTimeRenderOption.SERIAL_NUMBER.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   includeValuesInResponse: JBool
  ##                          : Determines if the update response should include the values
  ## of the cells that were updated. By default, responses
  ## do not include the updated values.
  ## If the range to write was larger than than the range actually written,
  ## the response will include all values in the requested range (excluding
  ## trailing empty rows and columns).
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   valueInputOption: JString
  ##                   : How the input data should be interpreted.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580044 = query.getOrDefault("key")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "key", valid_580044
  var valid_580045 = query.getOrDefault("prettyPrint")
  valid_580045 = validateParameter(valid_580045, JBool, required = false,
                                 default = newJBool(true))
  if valid_580045 != nil:
    section.add "prettyPrint", valid_580045
  var valid_580046 = query.getOrDefault("oauth_token")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "oauth_token", valid_580046
  var valid_580047 = query.getOrDefault("$.xgafv")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = newJString("1"))
  if valid_580047 != nil:
    section.add "$.xgafv", valid_580047
  var valid_580048 = query.getOrDefault("responseValueRenderOption")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_580048 != nil:
    section.add "responseValueRenderOption", valid_580048
  var valid_580049 = query.getOrDefault("responseDateTimeRenderOption")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_580049 != nil:
    section.add "responseDateTimeRenderOption", valid_580049
  var valid_580050 = query.getOrDefault("alt")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = newJString("json"))
  if valid_580050 != nil:
    section.add "alt", valid_580050
  var valid_580051 = query.getOrDefault("uploadType")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "uploadType", valid_580051
  var valid_580052 = query.getOrDefault("includeValuesInResponse")
  valid_580052 = validateParameter(valid_580052, JBool, required = false, default = nil)
  if valid_580052 != nil:
    section.add "includeValuesInResponse", valid_580052
  var valid_580053 = query.getOrDefault("quotaUser")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "quotaUser", valid_580053
  var valid_580054 = query.getOrDefault("callback")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "callback", valid_580054
  var valid_580055 = query.getOrDefault("valueInputOption")
  valid_580055 = validateParameter(valid_580055, JString, required = false, default = newJString(
      "INPUT_VALUE_OPTION_UNSPECIFIED"))
  if valid_580055 != nil:
    section.add "valueInputOption", valid_580055
  var valid_580056 = query.getOrDefault("fields")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "fields", valid_580056
  var valid_580057 = query.getOrDefault("access_token")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "access_token", valid_580057
  var valid_580058 = query.getOrDefault("upload_protocol")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "upload_protocol", valid_580058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580060: Call_SheetsSpreadsheetsValuesUpdate_580039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets values in a range of a spreadsheet.
  ## The caller must specify the spreadsheet ID, range, and
  ## a valueInputOption.
  ## 
  let valid = call_580060.validator(path, query, header, formData, body)
  let scheme = call_580060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580060.url(scheme.get, call_580060.host, call_580060.base,
                         call_580060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580060, url, valid)

proc call*(call_580061: Call_SheetsSpreadsheetsValuesUpdate_580039;
          spreadsheetId: string; range: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          responseValueRenderOption: string = "FORMATTED_VALUE";
          responseDateTimeRenderOption: string = "SERIAL_NUMBER";
          alt: string = "json"; uploadType: string = "";
          includeValuesInResponse: bool = false; quotaUser: string = "";
          body: JsonNode = nil; callback: string = "";
          valueInputOption: string = "INPUT_VALUE_OPTION_UNSPECIFIED";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsValuesUpdate
  ## Sets values in a range of a spreadsheet.
  ## The caller must specify the spreadsheet ID, range, and
  ## a valueInputOption.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   responseValueRenderOption: string
  ##                            : Determines how values in the response should be rendered.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   responseDateTimeRenderOption: string
  ##                               : Determines how dates, times, and durations in the response should be
  ## rendered. This is ignored if response_value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is
  ## DateTimeRenderOption.SERIAL_NUMBER.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   includeValuesInResponse: bool
  ##                          : Determines if the update response should include the values
  ## of the cells that were updated. By default, responses
  ## do not include the updated values.
  ## If the range to write was larger than than the range actually written,
  ## the response will include all values in the requested range (excluding
  ## trailing empty rows and columns).
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   range: string (required)
  ##        : The A1 notation of the values to update.
  ##   valueInputOption: string
  ##                   : How the input data should be interpreted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580062 = newJObject()
  var query_580063 = newJObject()
  var body_580064 = newJObject()
  add(query_580063, "key", newJString(key))
  add(query_580063, "prettyPrint", newJBool(prettyPrint))
  add(query_580063, "oauth_token", newJString(oauthToken))
  add(query_580063, "$.xgafv", newJString(Xgafv))
  add(query_580063, "responseValueRenderOption",
      newJString(responseValueRenderOption))
  add(query_580063, "responseDateTimeRenderOption",
      newJString(responseDateTimeRenderOption))
  add(query_580063, "alt", newJString(alt))
  add(query_580063, "uploadType", newJString(uploadType))
  add(query_580063, "includeValuesInResponse", newJBool(includeValuesInResponse))
  add(query_580063, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580064 = body
  add(query_580063, "callback", newJString(callback))
  add(path_580062, "spreadsheetId", newJString(spreadsheetId))
  add(path_580062, "range", newJString(range))
  add(query_580063, "valueInputOption", newJString(valueInputOption))
  add(query_580063, "fields", newJString(fields))
  add(query_580063, "access_token", newJString(accessToken))
  add(query_580063, "upload_protocol", newJString(uploadProtocol))
  result = call_580061.call(path_580062, query_580063, nil, nil, body_580064)

var sheetsSpreadsheetsValuesUpdate* = Call_SheetsSpreadsheetsValuesUpdate_580039(
    name: "sheetsSpreadsheetsValuesUpdate", meth: HttpMethod.HttpPut,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}",
    validator: validate_SheetsSpreadsheetsValuesUpdate_580040, base: "/",
    url: url_SheetsSpreadsheetsValuesUpdate_580041, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesGet_580016 = ref object of OpenApiRestCall_579373
proc url_SheetsSpreadsheetsValuesGet_580018(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  assert "range" in path, "`range` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/values/"),
               (kind: VariableSegment, value: "range")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesGet_580017(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a range of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and a range.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to retrieve data from.
  ##   range: JString (required)
  ##        : The A1 notation of the values to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_580019 = path.getOrDefault("spreadsheetId")
  valid_580019 = validateParameter(valid_580019, JString, required = true,
                                 default = nil)
  if valid_580019 != nil:
    section.add "spreadsheetId", valid_580019
  var valid_580020 = path.getOrDefault("range")
  valid_580020 = validateParameter(valid_580020, JString, required = true,
                                 default = nil)
  if valid_580020 != nil:
    section.add "range", valid_580020
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   majorDimension: JString
  ##                 : The major dimension that results should use.
  ## 
  ## For example, if the spreadsheet data is: `A1=1,B1=2,A2=3,B2=4`,
  ## then requesting `range=A1:B2,majorDimension=ROWS` will return
  ## `[[1,2],[3,4]]`,
  ## whereas requesting `range=A1:B2,majorDimension=COLUMNS` will return
  ## `[[1,3],[2,4]]`.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   dateTimeRenderOption: JString
  ##                       : How dates, times, and durations should be represented in the output.
  ## This is ignored if value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   valueRenderOption: JString
  ##                    : How values should be represented in the output.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  section = newJObject()
  var valid_580021 = query.getOrDefault("key")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "key", valid_580021
  var valid_580022 = query.getOrDefault("prettyPrint")
  valid_580022 = validateParameter(valid_580022, JBool, required = false,
                                 default = newJBool(true))
  if valid_580022 != nil:
    section.add "prettyPrint", valid_580022
  var valid_580023 = query.getOrDefault("oauth_token")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "oauth_token", valid_580023
  var valid_580024 = query.getOrDefault("majorDimension")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = newJString("DIMENSION_UNSPECIFIED"))
  if valid_580024 != nil:
    section.add "majorDimension", valid_580024
  var valid_580025 = query.getOrDefault("$.xgafv")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = newJString("1"))
  if valid_580025 != nil:
    section.add "$.xgafv", valid_580025
  var valid_580026 = query.getOrDefault("alt")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = newJString("json"))
  if valid_580026 != nil:
    section.add "alt", valid_580026
  var valid_580027 = query.getOrDefault("uploadType")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "uploadType", valid_580027
  var valid_580028 = query.getOrDefault("quotaUser")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "quotaUser", valid_580028
  var valid_580029 = query.getOrDefault("dateTimeRenderOption")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_580029 != nil:
    section.add "dateTimeRenderOption", valid_580029
  var valid_580030 = query.getOrDefault("callback")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "callback", valid_580030
  var valid_580031 = query.getOrDefault("fields")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "fields", valid_580031
  var valid_580032 = query.getOrDefault("access_token")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "access_token", valid_580032
  var valid_580033 = query.getOrDefault("upload_protocol")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "upload_protocol", valid_580033
  var valid_580034 = query.getOrDefault("valueRenderOption")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_580034 != nil:
    section.add "valueRenderOption", valid_580034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580035: Call_SheetsSpreadsheetsValuesGet_580016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a range of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and a range.
  ## 
  let valid = call_580035.validator(path, query, header, formData, body)
  let scheme = call_580035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580035.url(scheme.get, call_580035.host, call_580035.base,
                         call_580035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580035, url, valid)

proc call*(call_580036: Call_SheetsSpreadsheetsValuesGet_580016;
          spreadsheetId: string; range: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          majorDimension: string = "DIMENSION_UNSPECIFIED"; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          dateTimeRenderOption: string = "SERIAL_NUMBER"; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          valueRenderOption: string = "FORMATTED_VALUE"): Recallable =
  ## sheetsSpreadsheetsValuesGet
  ## Returns a range of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and a range.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   majorDimension: string
  ##                 : The major dimension that results should use.
  ## 
  ## For example, if the spreadsheet data is: `A1=1,B1=2,A2=3,B2=4`,
  ## then requesting `range=A1:B2,majorDimension=ROWS` will return
  ## `[[1,2],[3,4]]`,
  ## whereas requesting `range=A1:B2,majorDimension=COLUMNS` will return
  ## `[[1,3],[2,4]]`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   dateTimeRenderOption: string
  ##                       : How dates, times, and durations should be represented in the output.
  ## This is ignored if value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve data from.
  ##   range: string (required)
  ##        : The A1 notation of the values to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   valueRenderOption: string
  ##                    : How values should be represented in the output.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  var path_580037 = newJObject()
  var query_580038 = newJObject()
  add(query_580038, "key", newJString(key))
  add(query_580038, "prettyPrint", newJBool(prettyPrint))
  add(query_580038, "oauth_token", newJString(oauthToken))
  add(query_580038, "majorDimension", newJString(majorDimension))
  add(query_580038, "$.xgafv", newJString(Xgafv))
  add(query_580038, "alt", newJString(alt))
  add(query_580038, "uploadType", newJString(uploadType))
  add(query_580038, "quotaUser", newJString(quotaUser))
  add(query_580038, "dateTimeRenderOption", newJString(dateTimeRenderOption))
  add(query_580038, "callback", newJString(callback))
  add(path_580037, "spreadsheetId", newJString(spreadsheetId))
  add(path_580037, "range", newJString(range))
  add(query_580038, "fields", newJString(fields))
  add(query_580038, "access_token", newJString(accessToken))
  add(query_580038, "upload_protocol", newJString(uploadProtocol))
  add(query_580038, "valueRenderOption", newJString(valueRenderOption))
  result = call_580036.call(path_580037, query_580038, nil, nil, nil)

var sheetsSpreadsheetsValuesGet* = Call_SheetsSpreadsheetsValuesGet_580016(
    name: "sheetsSpreadsheetsValuesGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}",
    validator: validate_SheetsSpreadsheetsValuesGet_580017, base: "/",
    url: url_SheetsSpreadsheetsValuesGet_580018, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesAppend_580065 = ref object of OpenApiRestCall_579373
proc url_SheetsSpreadsheetsValuesAppend_580067(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  assert "range" in path, "`range` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/values/"),
               (kind: VariableSegment, value: "range"),
               (kind: ConstantSegment, value: ":append")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesAppend_580066(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Appends values to a spreadsheet. The input range is used to search for
  ## existing data and find a "table" within that range. Values will be
  ## appended to the next row of the table, starting with the first column of
  ## the table. See the
  ## [guide](/sheets/api/guides/values#appending_values)
  ## and
  ## [sample code](/sheets/api/samples/writing#append_values)
  ## for specific details of how tables are detected and data is appended.
  ## 
  ## The caller must specify the spreadsheet ID, range, and
  ## a valueInputOption.  The `valueInputOption` only
  ## controls how the input data will be added to the sheet (column-wise or
  ## row-wise), it does not influence what cell the data starts being written
  ## to.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to update.
  ##   range: JString (required)
  ##        : The A1 notation of a range to search for a logical table of data.
  ## Values will be appended after the last row of the table.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_580068 = path.getOrDefault("spreadsheetId")
  valid_580068 = validateParameter(valid_580068, JString, required = true,
                                 default = nil)
  if valid_580068 != nil:
    section.add "spreadsheetId", valid_580068
  var valid_580069 = path.getOrDefault("range")
  valid_580069 = validateParameter(valid_580069, JString, required = true,
                                 default = nil)
  if valid_580069 != nil:
    section.add "range", valid_580069
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   insertDataOption: JString
  ##                   : How the input data should be inserted.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   responseValueRenderOption: JString
  ##                            : Determines how values in the response should be rendered.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   responseDateTimeRenderOption: JString
  ##                               : Determines how dates, times, and durations in the response should be
  ## rendered. This is ignored if response_value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   includeValuesInResponse: JBool
  ##                          : Determines if the update response should include the values
  ## of the cells that were appended. By default, responses
  ## do not include the updated values.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   valueInputOption: JString
  ##                   : How the input data should be interpreted.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580070 = query.getOrDefault("key")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "key", valid_580070
  var valid_580071 = query.getOrDefault("insertDataOption")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = newJString("OVERWRITE"))
  if valid_580071 != nil:
    section.add "insertDataOption", valid_580071
  var valid_580072 = query.getOrDefault("prettyPrint")
  valid_580072 = validateParameter(valid_580072, JBool, required = false,
                                 default = newJBool(true))
  if valid_580072 != nil:
    section.add "prettyPrint", valid_580072
  var valid_580073 = query.getOrDefault("oauth_token")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "oauth_token", valid_580073
  var valid_580074 = query.getOrDefault("$.xgafv")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = newJString("1"))
  if valid_580074 != nil:
    section.add "$.xgafv", valid_580074
  var valid_580075 = query.getOrDefault("responseValueRenderOption")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_580075 != nil:
    section.add "responseValueRenderOption", valid_580075
  var valid_580076 = query.getOrDefault("responseDateTimeRenderOption")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_580076 != nil:
    section.add "responseDateTimeRenderOption", valid_580076
  var valid_580077 = query.getOrDefault("alt")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = newJString("json"))
  if valid_580077 != nil:
    section.add "alt", valid_580077
  var valid_580078 = query.getOrDefault("uploadType")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "uploadType", valid_580078
  var valid_580079 = query.getOrDefault("includeValuesInResponse")
  valid_580079 = validateParameter(valid_580079, JBool, required = false, default = nil)
  if valid_580079 != nil:
    section.add "includeValuesInResponse", valid_580079
  var valid_580080 = query.getOrDefault("quotaUser")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "quotaUser", valid_580080
  var valid_580081 = query.getOrDefault("callback")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "callback", valid_580081
  var valid_580082 = query.getOrDefault("valueInputOption")
  valid_580082 = validateParameter(valid_580082, JString, required = false, default = newJString(
      "INPUT_VALUE_OPTION_UNSPECIFIED"))
  if valid_580082 != nil:
    section.add "valueInputOption", valid_580082
  var valid_580083 = query.getOrDefault("fields")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "fields", valid_580083
  var valid_580084 = query.getOrDefault("access_token")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "access_token", valid_580084
  var valid_580085 = query.getOrDefault("upload_protocol")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "upload_protocol", valid_580085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580087: Call_SheetsSpreadsheetsValuesAppend_580065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Appends values to a spreadsheet. The input range is used to search for
  ## existing data and find a "table" within that range. Values will be
  ## appended to the next row of the table, starting with the first column of
  ## the table. See the
  ## [guide](/sheets/api/guides/values#appending_values)
  ## and
  ## [sample code](/sheets/api/samples/writing#append_values)
  ## for specific details of how tables are detected and data is appended.
  ## 
  ## The caller must specify the spreadsheet ID, range, and
  ## a valueInputOption.  The `valueInputOption` only
  ## controls how the input data will be added to the sheet (column-wise or
  ## row-wise), it does not influence what cell the data starts being written
  ## to.
  ## 
  let valid = call_580087.validator(path, query, header, formData, body)
  let scheme = call_580087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580087.url(scheme.get, call_580087.host, call_580087.base,
                         call_580087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580087, url, valid)

proc call*(call_580088: Call_SheetsSpreadsheetsValuesAppend_580065;
          spreadsheetId: string; range: string; key: string = "";
          insertDataOption: string = "OVERWRITE"; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          responseValueRenderOption: string = "FORMATTED_VALUE";
          responseDateTimeRenderOption: string = "SERIAL_NUMBER";
          alt: string = "json"; uploadType: string = "";
          includeValuesInResponse: bool = false; quotaUser: string = "";
          body: JsonNode = nil; callback: string = "";
          valueInputOption: string = "INPUT_VALUE_OPTION_UNSPECIFIED";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsValuesAppend
  ## Appends values to a spreadsheet. The input range is used to search for
  ## existing data and find a "table" within that range. Values will be
  ## appended to the next row of the table, starting with the first column of
  ## the table. See the
  ## [guide](/sheets/api/guides/values#appending_values)
  ## and
  ## [sample code](/sheets/api/samples/writing#append_values)
  ## for specific details of how tables are detected and data is appended.
  ## 
  ## The caller must specify the spreadsheet ID, range, and
  ## a valueInputOption.  The `valueInputOption` only
  ## controls how the input data will be added to the sheet (column-wise or
  ## row-wise), it does not influence what cell the data starts being written
  ## to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   insertDataOption: string
  ##                   : How the input data should be inserted.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   responseValueRenderOption: string
  ##                            : Determines how values in the response should be rendered.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   responseDateTimeRenderOption: string
  ##                               : Determines how dates, times, and durations in the response should be
  ## rendered. This is ignored if response_value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   includeValuesInResponse: bool
  ##                          : Determines if the update response should include the values
  ## of the cells that were appended. By default, responses
  ## do not include the updated values.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   range: string (required)
  ##        : The A1 notation of a range to search for a logical table of data.
  ## Values will be appended after the last row of the table.
  ##   valueInputOption: string
  ##                   : How the input data should be interpreted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580089 = newJObject()
  var query_580090 = newJObject()
  var body_580091 = newJObject()
  add(query_580090, "key", newJString(key))
  add(query_580090, "insertDataOption", newJString(insertDataOption))
  add(query_580090, "prettyPrint", newJBool(prettyPrint))
  add(query_580090, "oauth_token", newJString(oauthToken))
  add(query_580090, "$.xgafv", newJString(Xgafv))
  add(query_580090, "responseValueRenderOption",
      newJString(responseValueRenderOption))
  add(query_580090, "responseDateTimeRenderOption",
      newJString(responseDateTimeRenderOption))
  add(query_580090, "alt", newJString(alt))
  add(query_580090, "uploadType", newJString(uploadType))
  add(query_580090, "includeValuesInResponse", newJBool(includeValuesInResponse))
  add(query_580090, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580091 = body
  add(query_580090, "callback", newJString(callback))
  add(path_580089, "spreadsheetId", newJString(spreadsheetId))
  add(path_580089, "range", newJString(range))
  add(query_580090, "valueInputOption", newJString(valueInputOption))
  add(query_580090, "fields", newJString(fields))
  add(query_580090, "access_token", newJString(accessToken))
  add(query_580090, "upload_protocol", newJString(uploadProtocol))
  result = call_580088.call(path_580089, query_580090, nil, nil, body_580091)

var sheetsSpreadsheetsValuesAppend* = Call_SheetsSpreadsheetsValuesAppend_580065(
    name: "sheetsSpreadsheetsValuesAppend", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}:append",
    validator: validate_SheetsSpreadsheetsValuesAppend_580066, base: "/",
    url: url_SheetsSpreadsheetsValuesAppend_580067, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesClear_580092 = ref object of OpenApiRestCall_579373
proc url_SheetsSpreadsheetsValuesClear_580094(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  assert "range" in path, "`range` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/values/"),
               (kind: VariableSegment, value: "range"),
               (kind: ConstantSegment, value: ":clear")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesClear_580093(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Clears values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and range.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to update.
  ##   range: JString (required)
  ##        : The A1 notation of the values to clear.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_580095 = path.getOrDefault("spreadsheetId")
  valid_580095 = validateParameter(valid_580095, JString, required = true,
                                 default = nil)
  if valid_580095 != nil:
    section.add "spreadsheetId", valid_580095
  var valid_580096 = path.getOrDefault("range")
  valid_580096 = validateParameter(valid_580096, JString, required = true,
                                 default = nil)
  if valid_580096 != nil:
    section.add "range", valid_580096
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580097 = query.getOrDefault("key")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "key", valid_580097
  var valid_580098 = query.getOrDefault("prettyPrint")
  valid_580098 = validateParameter(valid_580098, JBool, required = false,
                                 default = newJBool(true))
  if valid_580098 != nil:
    section.add "prettyPrint", valid_580098
  var valid_580099 = query.getOrDefault("oauth_token")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "oauth_token", valid_580099
  var valid_580100 = query.getOrDefault("$.xgafv")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = newJString("1"))
  if valid_580100 != nil:
    section.add "$.xgafv", valid_580100
  var valid_580101 = query.getOrDefault("alt")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = newJString("json"))
  if valid_580101 != nil:
    section.add "alt", valid_580101
  var valid_580102 = query.getOrDefault("uploadType")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "uploadType", valid_580102
  var valid_580103 = query.getOrDefault("quotaUser")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "quotaUser", valid_580103
  var valid_580104 = query.getOrDefault("callback")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "callback", valid_580104
  var valid_580105 = query.getOrDefault("fields")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "fields", valid_580105
  var valid_580106 = query.getOrDefault("access_token")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "access_token", valid_580106
  var valid_580107 = query.getOrDefault("upload_protocol")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "upload_protocol", valid_580107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580109: Call_SheetsSpreadsheetsValuesClear_580092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clears values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and range.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ## 
  let valid = call_580109.validator(path, query, header, formData, body)
  let scheme = call_580109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580109.url(scheme.get, call_580109.host, call_580109.base,
                         call_580109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580109, url, valid)

proc call*(call_580110: Call_SheetsSpreadsheetsValuesClear_580092;
          spreadsheetId: string; range: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsValuesClear
  ## Clears values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and range.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   range: string (required)
  ##        : The A1 notation of the values to clear.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580111 = newJObject()
  var query_580112 = newJObject()
  var body_580113 = newJObject()
  add(query_580112, "key", newJString(key))
  add(query_580112, "prettyPrint", newJBool(prettyPrint))
  add(query_580112, "oauth_token", newJString(oauthToken))
  add(query_580112, "$.xgafv", newJString(Xgafv))
  add(query_580112, "alt", newJString(alt))
  add(query_580112, "uploadType", newJString(uploadType))
  add(query_580112, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580113 = body
  add(query_580112, "callback", newJString(callback))
  add(path_580111, "spreadsheetId", newJString(spreadsheetId))
  add(path_580111, "range", newJString(range))
  add(query_580112, "fields", newJString(fields))
  add(query_580112, "access_token", newJString(accessToken))
  add(query_580112, "upload_protocol", newJString(uploadProtocol))
  result = call_580110.call(path_580111, query_580112, nil, nil, body_580113)

var sheetsSpreadsheetsValuesClear* = Call_SheetsSpreadsheetsValuesClear_580092(
    name: "sheetsSpreadsheetsValuesClear", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}:clear",
    validator: validate_SheetsSpreadsheetsValuesClear_580093, base: "/",
    url: url_SheetsSpreadsheetsValuesClear_580094, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchClear_580114 = ref object of OpenApiRestCall_579373
proc url_SheetsSpreadsheetsValuesBatchClear_580116(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/values:batchClear")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesBatchClear_580115(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_580117 = path.getOrDefault("spreadsheetId")
  valid_580117 = validateParameter(valid_580117, JString, required = true,
                                 default = nil)
  if valid_580117 != nil:
    section.add "spreadsheetId", valid_580117
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580118 = query.getOrDefault("key")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "key", valid_580118
  var valid_580119 = query.getOrDefault("prettyPrint")
  valid_580119 = validateParameter(valid_580119, JBool, required = false,
                                 default = newJBool(true))
  if valid_580119 != nil:
    section.add "prettyPrint", valid_580119
  var valid_580120 = query.getOrDefault("oauth_token")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "oauth_token", valid_580120
  var valid_580121 = query.getOrDefault("$.xgafv")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = newJString("1"))
  if valid_580121 != nil:
    section.add "$.xgafv", valid_580121
  var valid_580122 = query.getOrDefault("alt")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = newJString("json"))
  if valid_580122 != nil:
    section.add "alt", valid_580122
  var valid_580123 = query.getOrDefault("uploadType")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "uploadType", valid_580123
  var valid_580124 = query.getOrDefault("quotaUser")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "quotaUser", valid_580124
  var valid_580125 = query.getOrDefault("callback")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "callback", valid_580125
  var valid_580126 = query.getOrDefault("fields")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "fields", valid_580126
  var valid_580127 = query.getOrDefault("access_token")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "access_token", valid_580127
  var valid_580128 = query.getOrDefault("upload_protocol")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "upload_protocol", valid_580128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580130: Call_SheetsSpreadsheetsValuesBatchClear_580114;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ## 
  let valid = call_580130.validator(path, query, header, formData, body)
  let scheme = call_580130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580130.url(scheme.get, call_580130.host, call_580130.base,
                         call_580130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580130, url, valid)

proc call*(call_580131: Call_SheetsSpreadsheetsValuesBatchClear_580114;
          spreadsheetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsValuesBatchClear
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580132 = newJObject()
  var query_580133 = newJObject()
  var body_580134 = newJObject()
  add(query_580133, "key", newJString(key))
  add(query_580133, "prettyPrint", newJBool(prettyPrint))
  add(query_580133, "oauth_token", newJString(oauthToken))
  add(query_580133, "$.xgafv", newJString(Xgafv))
  add(query_580133, "alt", newJString(alt))
  add(query_580133, "uploadType", newJString(uploadType))
  add(query_580133, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580134 = body
  add(query_580133, "callback", newJString(callback))
  add(path_580132, "spreadsheetId", newJString(spreadsheetId))
  add(query_580133, "fields", newJString(fields))
  add(query_580133, "access_token", newJString(accessToken))
  add(query_580133, "upload_protocol", newJString(uploadProtocol))
  result = call_580131.call(path_580132, query_580133, nil, nil, body_580134)

var sheetsSpreadsheetsValuesBatchClear* = Call_SheetsSpreadsheetsValuesBatchClear_580114(
    name: "sheetsSpreadsheetsValuesBatchClear", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchClear",
    validator: validate_SheetsSpreadsheetsValuesBatchClear_580115, base: "/",
    url: url_SheetsSpreadsheetsValuesBatchClear_580116, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_580135 = ref object of OpenApiRestCall_579373
proc url_SheetsSpreadsheetsValuesBatchClearByDataFilter_580137(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/values:batchClearByDataFilter")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesBatchClearByDataFilter_580136(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters. Ranges matching any of the specified data
  ## filters will be cleared.  Only values are cleared -- all other properties
  ## of the cell (such as formatting, data validation, etc..) are kept.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_580138 = path.getOrDefault("spreadsheetId")
  valid_580138 = validateParameter(valid_580138, JString, required = true,
                                 default = nil)
  if valid_580138 != nil:
    section.add "spreadsheetId", valid_580138
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580139 = query.getOrDefault("key")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "key", valid_580139
  var valid_580140 = query.getOrDefault("prettyPrint")
  valid_580140 = validateParameter(valid_580140, JBool, required = false,
                                 default = newJBool(true))
  if valid_580140 != nil:
    section.add "prettyPrint", valid_580140
  var valid_580141 = query.getOrDefault("oauth_token")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "oauth_token", valid_580141
  var valid_580142 = query.getOrDefault("$.xgafv")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = newJString("1"))
  if valid_580142 != nil:
    section.add "$.xgafv", valid_580142
  var valid_580143 = query.getOrDefault("alt")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = newJString("json"))
  if valid_580143 != nil:
    section.add "alt", valid_580143
  var valid_580144 = query.getOrDefault("uploadType")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "uploadType", valid_580144
  var valid_580145 = query.getOrDefault("quotaUser")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "quotaUser", valid_580145
  var valid_580146 = query.getOrDefault("callback")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "callback", valid_580146
  var valid_580147 = query.getOrDefault("fields")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "fields", valid_580147
  var valid_580148 = query.getOrDefault("access_token")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "access_token", valid_580148
  var valid_580149 = query.getOrDefault("upload_protocol")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "upload_protocol", valid_580149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580151: Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_580135;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters. Ranges matching any of the specified data
  ## filters will be cleared.  Only values are cleared -- all other properties
  ## of the cell (such as formatting, data validation, etc..) are kept.
  ## 
  let valid = call_580151.validator(path, query, header, formData, body)
  let scheme = call_580151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580151.url(scheme.get, call_580151.host, call_580151.base,
                         call_580151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580151, url, valid)

proc call*(call_580152: Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_580135;
          spreadsheetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsValuesBatchClearByDataFilter
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters. Ranges matching any of the specified data
  ## filters will be cleared.  Only values are cleared -- all other properties
  ## of the cell (such as formatting, data validation, etc..) are kept.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580153 = newJObject()
  var query_580154 = newJObject()
  var body_580155 = newJObject()
  add(query_580154, "key", newJString(key))
  add(query_580154, "prettyPrint", newJBool(prettyPrint))
  add(query_580154, "oauth_token", newJString(oauthToken))
  add(query_580154, "$.xgafv", newJString(Xgafv))
  add(query_580154, "alt", newJString(alt))
  add(query_580154, "uploadType", newJString(uploadType))
  add(query_580154, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580155 = body
  add(query_580154, "callback", newJString(callback))
  add(path_580153, "spreadsheetId", newJString(spreadsheetId))
  add(query_580154, "fields", newJString(fields))
  add(query_580154, "access_token", newJString(accessToken))
  add(query_580154, "upload_protocol", newJString(uploadProtocol))
  result = call_580152.call(path_580153, query_580154, nil, nil, body_580155)

var sheetsSpreadsheetsValuesBatchClearByDataFilter* = Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_580135(
    name: "sheetsSpreadsheetsValuesBatchClearByDataFilter",
    meth: HttpMethod.HttpPost, host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchClearByDataFilter",
    validator: validate_SheetsSpreadsheetsValuesBatchClearByDataFilter_580136,
    base: "/", url: url_SheetsSpreadsheetsValuesBatchClearByDataFilter_580137,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchGet_580156 = ref object of OpenApiRestCall_579373
proc url_SheetsSpreadsheetsValuesBatchGet_580158(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/values:batchGet")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesBatchGet_580157(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to retrieve data from.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_580159 = path.getOrDefault("spreadsheetId")
  valid_580159 = validateParameter(valid_580159, JString, required = true,
                                 default = nil)
  if valid_580159 != nil:
    section.add "spreadsheetId", valid_580159
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ranges: JArray
  ##         : The A1 notation of the values to retrieve.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   majorDimension: JString
  ##                 : The major dimension that results should use.
  ## 
  ## For example, if the spreadsheet data is: `A1=1,B1=2,A2=3,B2=4`,
  ## then requesting `range=A1:B2,majorDimension=ROWS` will return
  ## `[[1,2],[3,4]]`,
  ## whereas requesting `range=A1:B2,majorDimension=COLUMNS` will return
  ## `[[1,3],[2,4]]`.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   dateTimeRenderOption: JString
  ##                       : How dates, times, and durations should be represented in the output.
  ## This is ignored if value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   valueRenderOption: JString
  ##                    : How values should be represented in the output.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  section = newJObject()
  var valid_580160 = query.getOrDefault("key")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "key", valid_580160
  var valid_580161 = query.getOrDefault("ranges")
  valid_580161 = validateParameter(valid_580161, JArray, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "ranges", valid_580161
  var valid_580162 = query.getOrDefault("prettyPrint")
  valid_580162 = validateParameter(valid_580162, JBool, required = false,
                                 default = newJBool(true))
  if valid_580162 != nil:
    section.add "prettyPrint", valid_580162
  var valid_580163 = query.getOrDefault("oauth_token")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "oauth_token", valid_580163
  var valid_580164 = query.getOrDefault("majorDimension")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = newJString("DIMENSION_UNSPECIFIED"))
  if valid_580164 != nil:
    section.add "majorDimension", valid_580164
  var valid_580165 = query.getOrDefault("$.xgafv")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = newJString("1"))
  if valid_580165 != nil:
    section.add "$.xgafv", valid_580165
  var valid_580166 = query.getOrDefault("alt")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = newJString("json"))
  if valid_580166 != nil:
    section.add "alt", valid_580166
  var valid_580167 = query.getOrDefault("uploadType")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "uploadType", valid_580167
  var valid_580168 = query.getOrDefault("quotaUser")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "quotaUser", valid_580168
  var valid_580169 = query.getOrDefault("dateTimeRenderOption")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_580169 != nil:
    section.add "dateTimeRenderOption", valid_580169
  var valid_580170 = query.getOrDefault("callback")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "callback", valid_580170
  var valid_580171 = query.getOrDefault("fields")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "fields", valid_580171
  var valid_580172 = query.getOrDefault("access_token")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "access_token", valid_580172
  var valid_580173 = query.getOrDefault("upload_protocol")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "upload_protocol", valid_580173
  var valid_580174 = query.getOrDefault("valueRenderOption")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_580174 != nil:
    section.add "valueRenderOption", valid_580174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580175: Call_SheetsSpreadsheetsValuesBatchGet_580156;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ## 
  let valid = call_580175.validator(path, query, header, formData, body)
  let scheme = call_580175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580175.url(scheme.get, call_580175.host, call_580175.base,
                         call_580175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580175, url, valid)

proc call*(call_580176: Call_SheetsSpreadsheetsValuesBatchGet_580156;
          spreadsheetId: string; key: string = ""; ranges: JsonNode = nil;
          prettyPrint: bool = true; oauthToken: string = "";
          majorDimension: string = "DIMENSION_UNSPECIFIED"; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          dateTimeRenderOption: string = "SERIAL_NUMBER"; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          valueRenderOption: string = "FORMATTED_VALUE"): Recallable =
  ## sheetsSpreadsheetsValuesBatchGet
  ## Returns one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ranges: JArray
  ##         : The A1 notation of the values to retrieve.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   majorDimension: string
  ##                 : The major dimension that results should use.
  ## 
  ## For example, if the spreadsheet data is: `A1=1,B1=2,A2=3,B2=4`,
  ## then requesting `range=A1:B2,majorDimension=ROWS` will return
  ## `[[1,2],[3,4]]`,
  ## whereas requesting `range=A1:B2,majorDimension=COLUMNS` will return
  ## `[[1,3],[2,4]]`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   dateTimeRenderOption: string
  ##                       : How dates, times, and durations should be represented in the output.
  ## This is ignored if value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve data from.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   valueRenderOption: string
  ##                    : How values should be represented in the output.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  var path_580177 = newJObject()
  var query_580178 = newJObject()
  add(query_580178, "key", newJString(key))
  if ranges != nil:
    query_580178.add "ranges", ranges
  add(query_580178, "prettyPrint", newJBool(prettyPrint))
  add(query_580178, "oauth_token", newJString(oauthToken))
  add(query_580178, "majorDimension", newJString(majorDimension))
  add(query_580178, "$.xgafv", newJString(Xgafv))
  add(query_580178, "alt", newJString(alt))
  add(query_580178, "uploadType", newJString(uploadType))
  add(query_580178, "quotaUser", newJString(quotaUser))
  add(query_580178, "dateTimeRenderOption", newJString(dateTimeRenderOption))
  add(query_580178, "callback", newJString(callback))
  add(path_580177, "spreadsheetId", newJString(spreadsheetId))
  add(query_580178, "fields", newJString(fields))
  add(query_580178, "access_token", newJString(accessToken))
  add(query_580178, "upload_protocol", newJString(uploadProtocol))
  add(query_580178, "valueRenderOption", newJString(valueRenderOption))
  result = call_580176.call(path_580177, query_580178, nil, nil, nil)

var sheetsSpreadsheetsValuesBatchGet* = Call_SheetsSpreadsheetsValuesBatchGet_580156(
    name: "sheetsSpreadsheetsValuesBatchGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchGet",
    validator: validate_SheetsSpreadsheetsValuesBatchGet_580157, base: "/",
    url: url_SheetsSpreadsheetsValuesBatchGet_580158, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_580179 = ref object of OpenApiRestCall_579373
proc url_SheetsSpreadsheetsValuesBatchGetByDataFilter_580181(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/values:batchGetByDataFilter")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesBatchGetByDataFilter_580180(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns one or more ranges of values that match the specified data filters.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters.  Ranges that match any of the data filters in
  ## the request will be returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to retrieve data from.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_580182 = path.getOrDefault("spreadsheetId")
  valid_580182 = validateParameter(valid_580182, JString, required = true,
                                 default = nil)
  if valid_580182 != nil:
    section.add "spreadsheetId", valid_580182
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580183 = query.getOrDefault("key")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "key", valid_580183
  var valid_580184 = query.getOrDefault("prettyPrint")
  valid_580184 = validateParameter(valid_580184, JBool, required = false,
                                 default = newJBool(true))
  if valid_580184 != nil:
    section.add "prettyPrint", valid_580184
  var valid_580185 = query.getOrDefault("oauth_token")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "oauth_token", valid_580185
  var valid_580186 = query.getOrDefault("$.xgafv")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = newJString("1"))
  if valid_580186 != nil:
    section.add "$.xgafv", valid_580186
  var valid_580187 = query.getOrDefault("alt")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = newJString("json"))
  if valid_580187 != nil:
    section.add "alt", valid_580187
  var valid_580188 = query.getOrDefault("uploadType")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "uploadType", valid_580188
  var valid_580189 = query.getOrDefault("quotaUser")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "quotaUser", valid_580189
  var valid_580190 = query.getOrDefault("callback")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "callback", valid_580190
  var valid_580191 = query.getOrDefault("fields")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "fields", valid_580191
  var valid_580192 = query.getOrDefault("access_token")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "access_token", valid_580192
  var valid_580193 = query.getOrDefault("upload_protocol")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "upload_protocol", valid_580193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580195: Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_580179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns one or more ranges of values that match the specified data filters.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters.  Ranges that match any of the data filters in
  ## the request will be returned.
  ## 
  let valid = call_580195.validator(path, query, header, formData, body)
  let scheme = call_580195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580195.url(scheme.get, call_580195.host, call_580195.base,
                         call_580195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580195, url, valid)

proc call*(call_580196: Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_580179;
          spreadsheetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsValuesBatchGetByDataFilter
  ## Returns one or more ranges of values that match the specified data filters.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters.  Ranges that match any of the data filters in
  ## the request will be returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve data from.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580197 = newJObject()
  var query_580198 = newJObject()
  var body_580199 = newJObject()
  add(query_580198, "key", newJString(key))
  add(query_580198, "prettyPrint", newJBool(prettyPrint))
  add(query_580198, "oauth_token", newJString(oauthToken))
  add(query_580198, "$.xgafv", newJString(Xgafv))
  add(query_580198, "alt", newJString(alt))
  add(query_580198, "uploadType", newJString(uploadType))
  add(query_580198, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580199 = body
  add(query_580198, "callback", newJString(callback))
  add(path_580197, "spreadsheetId", newJString(spreadsheetId))
  add(query_580198, "fields", newJString(fields))
  add(query_580198, "access_token", newJString(accessToken))
  add(query_580198, "upload_protocol", newJString(uploadProtocol))
  result = call_580196.call(path_580197, query_580198, nil, nil, body_580199)

var sheetsSpreadsheetsValuesBatchGetByDataFilter* = Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_580179(
    name: "sheetsSpreadsheetsValuesBatchGetByDataFilter",
    meth: HttpMethod.HttpPost, host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchGetByDataFilter",
    validator: validate_SheetsSpreadsheetsValuesBatchGetByDataFilter_580180,
    base: "/", url: url_SheetsSpreadsheetsValuesBatchGetByDataFilter_580181,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchUpdate_580200 = ref object of OpenApiRestCall_579373
proc url_SheetsSpreadsheetsValuesBatchUpdate_580202(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/values:batchUpdate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesBatchUpdate_580201(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## ValueRanges.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_580203 = path.getOrDefault("spreadsheetId")
  valid_580203 = validateParameter(valid_580203, JString, required = true,
                                 default = nil)
  if valid_580203 != nil:
    section.add "spreadsheetId", valid_580203
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580204 = query.getOrDefault("key")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "key", valid_580204
  var valid_580205 = query.getOrDefault("prettyPrint")
  valid_580205 = validateParameter(valid_580205, JBool, required = false,
                                 default = newJBool(true))
  if valid_580205 != nil:
    section.add "prettyPrint", valid_580205
  var valid_580206 = query.getOrDefault("oauth_token")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "oauth_token", valid_580206
  var valid_580207 = query.getOrDefault("$.xgafv")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = newJString("1"))
  if valid_580207 != nil:
    section.add "$.xgafv", valid_580207
  var valid_580208 = query.getOrDefault("alt")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = newJString("json"))
  if valid_580208 != nil:
    section.add "alt", valid_580208
  var valid_580209 = query.getOrDefault("uploadType")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "uploadType", valid_580209
  var valid_580210 = query.getOrDefault("quotaUser")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "quotaUser", valid_580210
  var valid_580211 = query.getOrDefault("callback")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "callback", valid_580211
  var valid_580212 = query.getOrDefault("fields")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "fields", valid_580212
  var valid_580213 = query.getOrDefault("access_token")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "access_token", valid_580213
  var valid_580214 = query.getOrDefault("upload_protocol")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "upload_protocol", valid_580214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580216: Call_SheetsSpreadsheetsValuesBatchUpdate_580200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## ValueRanges.
  ## 
  let valid = call_580216.validator(path, query, header, formData, body)
  let scheme = call_580216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580216.url(scheme.get, call_580216.host, call_580216.base,
                         call_580216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580216, url, valid)

proc call*(call_580217: Call_SheetsSpreadsheetsValuesBatchUpdate_580200;
          spreadsheetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsValuesBatchUpdate
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## ValueRanges.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580218 = newJObject()
  var query_580219 = newJObject()
  var body_580220 = newJObject()
  add(query_580219, "key", newJString(key))
  add(query_580219, "prettyPrint", newJBool(prettyPrint))
  add(query_580219, "oauth_token", newJString(oauthToken))
  add(query_580219, "$.xgafv", newJString(Xgafv))
  add(query_580219, "alt", newJString(alt))
  add(query_580219, "uploadType", newJString(uploadType))
  add(query_580219, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580220 = body
  add(query_580219, "callback", newJString(callback))
  add(path_580218, "spreadsheetId", newJString(spreadsheetId))
  add(query_580219, "fields", newJString(fields))
  add(query_580219, "access_token", newJString(accessToken))
  add(query_580219, "upload_protocol", newJString(uploadProtocol))
  result = call_580217.call(path_580218, query_580219, nil, nil, body_580220)

var sheetsSpreadsheetsValuesBatchUpdate* = Call_SheetsSpreadsheetsValuesBatchUpdate_580200(
    name: "sheetsSpreadsheetsValuesBatchUpdate", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchUpdate",
    validator: validate_SheetsSpreadsheetsValuesBatchUpdate_580201, base: "/",
    url: url_SheetsSpreadsheetsValuesBatchUpdate_580202, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_580221 = ref object of OpenApiRestCall_579373
proc url_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_580223(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"), (
        kind: ConstantSegment, value: "/values:batchUpdateByDataFilter")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_580222(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## DataFilterValueRanges.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_580224 = path.getOrDefault("spreadsheetId")
  valid_580224 = validateParameter(valid_580224, JString, required = true,
                                 default = nil)
  if valid_580224 != nil:
    section.add "spreadsheetId", valid_580224
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580225 = query.getOrDefault("key")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "key", valid_580225
  var valid_580226 = query.getOrDefault("prettyPrint")
  valid_580226 = validateParameter(valid_580226, JBool, required = false,
                                 default = newJBool(true))
  if valid_580226 != nil:
    section.add "prettyPrint", valid_580226
  var valid_580227 = query.getOrDefault("oauth_token")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "oauth_token", valid_580227
  var valid_580228 = query.getOrDefault("$.xgafv")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = newJString("1"))
  if valid_580228 != nil:
    section.add "$.xgafv", valid_580228
  var valid_580229 = query.getOrDefault("alt")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = newJString("json"))
  if valid_580229 != nil:
    section.add "alt", valid_580229
  var valid_580230 = query.getOrDefault("uploadType")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "uploadType", valid_580230
  var valid_580231 = query.getOrDefault("quotaUser")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "quotaUser", valid_580231
  var valid_580232 = query.getOrDefault("callback")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "callback", valid_580232
  var valid_580233 = query.getOrDefault("fields")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "fields", valid_580233
  var valid_580234 = query.getOrDefault("access_token")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "access_token", valid_580234
  var valid_580235 = query.getOrDefault("upload_protocol")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "upload_protocol", valid_580235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580237: Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_580221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## DataFilterValueRanges.
  ## 
  let valid = call_580237.validator(path, query, header, formData, body)
  let scheme = call_580237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580237.url(scheme.get, call_580237.host, call_580237.base,
                         call_580237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580237, url, valid)

proc call*(call_580238: Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_580221;
          spreadsheetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsValuesBatchUpdateByDataFilter
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## DataFilterValueRanges.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580239 = newJObject()
  var query_580240 = newJObject()
  var body_580241 = newJObject()
  add(query_580240, "key", newJString(key))
  add(query_580240, "prettyPrint", newJBool(prettyPrint))
  add(query_580240, "oauth_token", newJString(oauthToken))
  add(query_580240, "$.xgafv", newJString(Xgafv))
  add(query_580240, "alt", newJString(alt))
  add(query_580240, "uploadType", newJString(uploadType))
  add(query_580240, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580241 = body
  add(query_580240, "callback", newJString(callback))
  add(path_580239, "spreadsheetId", newJString(spreadsheetId))
  add(query_580240, "fields", newJString(fields))
  add(query_580240, "access_token", newJString(accessToken))
  add(query_580240, "upload_protocol", newJString(uploadProtocol))
  result = call_580238.call(path_580239, query_580240, nil, nil, body_580241)

var sheetsSpreadsheetsValuesBatchUpdateByDataFilter* = Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_580221(
    name: "sheetsSpreadsheetsValuesBatchUpdateByDataFilter",
    meth: HttpMethod.HttpPost, host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchUpdateByDataFilter",
    validator: validate_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_580222,
    base: "/", url: url_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_580223,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsBatchUpdate_580242 = ref object of OpenApiRestCall_579373
proc url_SheetsSpreadsheetsBatchUpdate_580244(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: ":batchUpdate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsBatchUpdate_580243(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Applies one or more updates to the spreadsheet.
  ## 
  ## Each request is validated before
  ## being applied. If any request is not valid then the entire request will
  ## fail and nothing will be applied.
  ## 
  ## Some requests have replies to
  ## give you some information about how
  ## they are applied. The replies will mirror the requests.  For example,
  ## if you applied 4 updates and the 3rd one had a reply, then the
  ## response will have 2 empty replies, the actual reply, and another empty
  ## reply, in that order.
  ## 
  ## Due to the collaborative nature of spreadsheets, it is not guaranteed that
  ## the spreadsheet will reflect exactly your changes after this completes,
  ## however it is guaranteed that the updates in the request will be
  ## applied together atomically. Your changes may be altered with respect to
  ## collaborator changes. If there are no collaborators, the spreadsheet
  ## should reflect your changes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The spreadsheet to apply the updates to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_580245 = path.getOrDefault("spreadsheetId")
  valid_580245 = validateParameter(valid_580245, JString, required = true,
                                 default = nil)
  if valid_580245 != nil:
    section.add "spreadsheetId", valid_580245
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580246 = query.getOrDefault("key")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "key", valid_580246
  var valid_580247 = query.getOrDefault("prettyPrint")
  valid_580247 = validateParameter(valid_580247, JBool, required = false,
                                 default = newJBool(true))
  if valid_580247 != nil:
    section.add "prettyPrint", valid_580247
  var valid_580248 = query.getOrDefault("oauth_token")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "oauth_token", valid_580248
  var valid_580249 = query.getOrDefault("$.xgafv")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = newJString("1"))
  if valid_580249 != nil:
    section.add "$.xgafv", valid_580249
  var valid_580250 = query.getOrDefault("alt")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = newJString("json"))
  if valid_580250 != nil:
    section.add "alt", valid_580250
  var valid_580251 = query.getOrDefault("uploadType")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "uploadType", valid_580251
  var valid_580252 = query.getOrDefault("quotaUser")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "quotaUser", valid_580252
  var valid_580253 = query.getOrDefault("callback")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "callback", valid_580253
  var valid_580254 = query.getOrDefault("fields")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "fields", valid_580254
  var valid_580255 = query.getOrDefault("access_token")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "access_token", valid_580255
  var valid_580256 = query.getOrDefault("upload_protocol")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "upload_protocol", valid_580256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580258: Call_SheetsSpreadsheetsBatchUpdate_580242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Applies one or more updates to the spreadsheet.
  ## 
  ## Each request is validated before
  ## being applied. If any request is not valid then the entire request will
  ## fail and nothing will be applied.
  ## 
  ## Some requests have replies to
  ## give you some information about how
  ## they are applied. The replies will mirror the requests.  For example,
  ## if you applied 4 updates and the 3rd one had a reply, then the
  ## response will have 2 empty replies, the actual reply, and another empty
  ## reply, in that order.
  ## 
  ## Due to the collaborative nature of spreadsheets, it is not guaranteed that
  ## the spreadsheet will reflect exactly your changes after this completes,
  ## however it is guaranteed that the updates in the request will be
  ## applied together atomically. Your changes may be altered with respect to
  ## collaborator changes. If there are no collaborators, the spreadsheet
  ## should reflect your changes.
  ## 
  let valid = call_580258.validator(path, query, header, formData, body)
  let scheme = call_580258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580258.url(scheme.get, call_580258.host, call_580258.base,
                         call_580258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580258, url, valid)

proc call*(call_580259: Call_SheetsSpreadsheetsBatchUpdate_580242;
          spreadsheetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsBatchUpdate
  ## Applies one or more updates to the spreadsheet.
  ## 
  ## Each request is validated before
  ## being applied. If any request is not valid then the entire request will
  ## fail and nothing will be applied.
  ## 
  ## Some requests have replies to
  ## give you some information about how
  ## they are applied. The replies will mirror the requests.  For example,
  ## if you applied 4 updates and the 3rd one had a reply, then the
  ## response will have 2 empty replies, the actual reply, and another empty
  ## reply, in that order.
  ## 
  ## Due to the collaborative nature of spreadsheets, it is not guaranteed that
  ## the spreadsheet will reflect exactly your changes after this completes,
  ## however it is guaranteed that the updates in the request will be
  ## applied together atomically. Your changes may be altered with respect to
  ## collaborator changes. If there are no collaborators, the spreadsheet
  ## should reflect your changes.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The spreadsheet to apply the updates to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580260 = newJObject()
  var query_580261 = newJObject()
  var body_580262 = newJObject()
  add(query_580261, "key", newJString(key))
  add(query_580261, "prettyPrint", newJBool(prettyPrint))
  add(query_580261, "oauth_token", newJString(oauthToken))
  add(query_580261, "$.xgafv", newJString(Xgafv))
  add(query_580261, "alt", newJString(alt))
  add(query_580261, "uploadType", newJString(uploadType))
  add(query_580261, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580262 = body
  add(query_580261, "callback", newJString(callback))
  add(path_580260, "spreadsheetId", newJString(spreadsheetId))
  add(query_580261, "fields", newJString(fields))
  add(query_580261, "access_token", newJString(accessToken))
  add(query_580261, "upload_protocol", newJString(uploadProtocol))
  result = call_580259.call(path_580260, query_580261, nil, nil, body_580262)

var sheetsSpreadsheetsBatchUpdate* = Call_SheetsSpreadsheetsBatchUpdate_580242(
    name: "sheetsSpreadsheetsBatchUpdate", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}:batchUpdate",
    validator: validate_SheetsSpreadsheetsBatchUpdate_580243, base: "/",
    url: url_SheetsSpreadsheetsBatchUpdate_580244, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsGetByDataFilter_580263 = ref object of OpenApiRestCall_579373
proc url_SheetsSpreadsheetsGetByDataFilter_580265(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: ":getByDataFilter")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsGetByDataFilter_580264(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the spreadsheet at the given ID.
  ## The caller must specify the spreadsheet ID.
  ## 
  ## This method differs from GetSpreadsheet in that it allows selecting
  ## which subsets of spreadsheet data to return by specifying a
  ## dataFilters parameter.
  ## Multiple DataFilters can be specified.  Specifying one or
  ## more data filters will return the portions of the spreadsheet that
  ## intersect ranges matched by any of the filters.
  ## 
  ## By default, data within grids will not be returned.
  ## You can include grid data one of two ways:
  ## 
  ## * Specify a field mask listing your desired fields using the `fields` URL
  ## parameter in HTTP
  ## 
  ## * Set the includeGridData
  ## parameter to true.  If a field mask is set, the `includeGridData`
  ## parameter is ignored
  ## 
  ## For large spreadsheets, it is recommended to retrieve only the specific
  ## fields of the spreadsheet that you want.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The spreadsheet to request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_580266 = path.getOrDefault("spreadsheetId")
  valid_580266 = validateParameter(valid_580266, JString, required = true,
                                 default = nil)
  if valid_580266 != nil:
    section.add "spreadsheetId", valid_580266
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580267 = query.getOrDefault("key")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "key", valid_580267
  var valid_580268 = query.getOrDefault("prettyPrint")
  valid_580268 = validateParameter(valid_580268, JBool, required = false,
                                 default = newJBool(true))
  if valid_580268 != nil:
    section.add "prettyPrint", valid_580268
  var valid_580269 = query.getOrDefault("oauth_token")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "oauth_token", valid_580269
  var valid_580270 = query.getOrDefault("$.xgafv")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = newJString("1"))
  if valid_580270 != nil:
    section.add "$.xgafv", valid_580270
  var valid_580271 = query.getOrDefault("alt")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = newJString("json"))
  if valid_580271 != nil:
    section.add "alt", valid_580271
  var valid_580272 = query.getOrDefault("uploadType")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "uploadType", valid_580272
  var valid_580273 = query.getOrDefault("quotaUser")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "quotaUser", valid_580273
  var valid_580274 = query.getOrDefault("callback")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "callback", valid_580274
  var valid_580275 = query.getOrDefault("fields")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "fields", valid_580275
  var valid_580276 = query.getOrDefault("access_token")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "access_token", valid_580276
  var valid_580277 = query.getOrDefault("upload_protocol")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "upload_protocol", valid_580277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580279: Call_SheetsSpreadsheetsGetByDataFilter_580263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the spreadsheet at the given ID.
  ## The caller must specify the spreadsheet ID.
  ## 
  ## This method differs from GetSpreadsheet in that it allows selecting
  ## which subsets of spreadsheet data to return by specifying a
  ## dataFilters parameter.
  ## Multiple DataFilters can be specified.  Specifying one or
  ## more data filters will return the portions of the spreadsheet that
  ## intersect ranges matched by any of the filters.
  ## 
  ## By default, data within grids will not be returned.
  ## You can include grid data one of two ways:
  ## 
  ## * Specify a field mask listing your desired fields using the `fields` URL
  ## parameter in HTTP
  ## 
  ## * Set the includeGridData
  ## parameter to true.  If a field mask is set, the `includeGridData`
  ## parameter is ignored
  ## 
  ## For large spreadsheets, it is recommended to retrieve only the specific
  ## fields of the spreadsheet that you want.
  ## 
  let valid = call_580279.validator(path, query, header, formData, body)
  let scheme = call_580279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580279.url(scheme.get, call_580279.host, call_580279.base,
                         call_580279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580279, url, valid)

proc call*(call_580280: Call_SheetsSpreadsheetsGetByDataFilter_580263;
          spreadsheetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsGetByDataFilter
  ## Returns the spreadsheet at the given ID.
  ## The caller must specify the spreadsheet ID.
  ## 
  ## This method differs from GetSpreadsheet in that it allows selecting
  ## which subsets of spreadsheet data to return by specifying a
  ## dataFilters parameter.
  ## Multiple DataFilters can be specified.  Specifying one or
  ## more data filters will return the portions of the spreadsheet that
  ## intersect ranges matched by any of the filters.
  ## 
  ## By default, data within grids will not be returned.
  ## You can include grid data one of two ways:
  ## 
  ## * Specify a field mask listing your desired fields using the `fields` URL
  ## parameter in HTTP
  ## 
  ## * Set the includeGridData
  ## parameter to true.  If a field mask is set, the `includeGridData`
  ## parameter is ignored
  ## 
  ## For large spreadsheets, it is recommended to retrieve only the specific
  ## fields of the spreadsheet that you want.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The spreadsheet to request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580281 = newJObject()
  var query_580282 = newJObject()
  var body_580283 = newJObject()
  add(query_580282, "key", newJString(key))
  add(query_580282, "prettyPrint", newJBool(prettyPrint))
  add(query_580282, "oauth_token", newJString(oauthToken))
  add(query_580282, "$.xgafv", newJString(Xgafv))
  add(query_580282, "alt", newJString(alt))
  add(query_580282, "uploadType", newJString(uploadType))
  add(query_580282, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580283 = body
  add(query_580282, "callback", newJString(callback))
  add(path_580281, "spreadsheetId", newJString(spreadsheetId))
  add(query_580282, "fields", newJString(fields))
  add(query_580282, "access_token", newJString(accessToken))
  add(query_580282, "upload_protocol", newJString(uploadProtocol))
  result = call_580280.call(path_580281, query_580282, nil, nil, body_580283)

var sheetsSpreadsheetsGetByDataFilter* = Call_SheetsSpreadsheetsGetByDataFilter_580263(
    name: "sheetsSpreadsheetsGetByDataFilter", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}:getByDataFilter",
    validator: validate_SheetsSpreadsheetsGetByDataFilter_580264, base: "/",
    url: url_SheetsSpreadsheetsGetByDataFilter_580265, schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
