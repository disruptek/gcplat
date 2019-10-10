
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "sheets"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SheetsSpreadsheetsCreate_588719 = ref object of OpenApiRestCall_588450
proc url_SheetsSpreadsheetsCreate_588721(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SheetsSpreadsheetsCreate_588720(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a spreadsheet, returning the newly created spreadsheet.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588833 = query.getOrDefault("upload_protocol")
  valid_588833 = validateParameter(valid_588833, JString, required = false,
                                 default = nil)
  if valid_588833 != nil:
    section.add "upload_protocol", valid_588833
  var valid_588834 = query.getOrDefault("fields")
  valid_588834 = validateParameter(valid_588834, JString, required = false,
                                 default = nil)
  if valid_588834 != nil:
    section.add "fields", valid_588834
  var valid_588835 = query.getOrDefault("quotaUser")
  valid_588835 = validateParameter(valid_588835, JString, required = false,
                                 default = nil)
  if valid_588835 != nil:
    section.add "quotaUser", valid_588835
  var valid_588849 = query.getOrDefault("alt")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = newJString("json"))
  if valid_588849 != nil:
    section.add "alt", valid_588849
  var valid_588850 = query.getOrDefault("oauth_token")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "oauth_token", valid_588850
  var valid_588851 = query.getOrDefault("callback")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "callback", valid_588851
  var valid_588852 = query.getOrDefault("access_token")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "access_token", valid_588852
  var valid_588853 = query.getOrDefault("uploadType")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = nil)
  if valid_588853 != nil:
    section.add "uploadType", valid_588853
  var valid_588854 = query.getOrDefault("key")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "key", valid_588854
  var valid_588855 = query.getOrDefault("$.xgafv")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("1"))
  if valid_588855 != nil:
    section.add "$.xgafv", valid_588855
  var valid_588856 = query.getOrDefault("prettyPrint")
  valid_588856 = validateParameter(valid_588856, JBool, required = false,
                                 default = newJBool(true))
  if valid_588856 != nil:
    section.add "prettyPrint", valid_588856
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

proc call*(call_588880: Call_SheetsSpreadsheetsCreate_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a spreadsheet, returning the newly created spreadsheet.
  ## 
  let valid = call_588880.validator(path, query, header, formData, body)
  let scheme = call_588880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588880.url(scheme.get, call_588880.host, call_588880.base,
                         call_588880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588880, url, valid)

proc call*(call_588951: Call_SheetsSpreadsheetsCreate_588719;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsCreate
  ## Creates a spreadsheet, returning the newly created spreadsheet.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588952 = newJObject()
  var body_588954 = newJObject()
  add(query_588952, "upload_protocol", newJString(uploadProtocol))
  add(query_588952, "fields", newJString(fields))
  add(query_588952, "quotaUser", newJString(quotaUser))
  add(query_588952, "alt", newJString(alt))
  add(query_588952, "oauth_token", newJString(oauthToken))
  add(query_588952, "callback", newJString(callback))
  add(query_588952, "access_token", newJString(accessToken))
  add(query_588952, "uploadType", newJString(uploadType))
  add(query_588952, "key", newJString(key))
  add(query_588952, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_588954 = body
  add(query_588952, "prettyPrint", newJBool(prettyPrint))
  result = call_588951.call(nil, query_588952, nil, nil, body_588954)

var sheetsSpreadsheetsCreate* = Call_SheetsSpreadsheetsCreate_588719(
    name: "sheetsSpreadsheetsCreate", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com", route: "/v4/spreadsheets",
    validator: validate_SheetsSpreadsheetsCreate_588720, base: "/",
    url: url_SheetsSpreadsheetsCreate_588721, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsGet_588993 = ref object of OpenApiRestCall_588450
proc url_SheetsSpreadsheetsGet_588995(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsGet_588994(path: JsonNode; query: JsonNode;
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
  var valid_589010 = path.getOrDefault("spreadsheetId")
  valid_589010 = validateParameter(valid_589010, JString, required = true,
                                 default = nil)
  if valid_589010 != nil:
    section.add "spreadsheetId", valid_589010
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   includeGridData: JBool
  ##                  : True if grid data should be returned.
  ## This parameter is ignored if a field mask was set in the request.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   ranges: JArray
  ##         : The ranges to retrieve from the spreadsheet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589011 = query.getOrDefault("upload_protocol")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "upload_protocol", valid_589011
  var valid_589012 = query.getOrDefault("fields")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "fields", valid_589012
  var valid_589013 = query.getOrDefault("quotaUser")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "quotaUser", valid_589013
  var valid_589014 = query.getOrDefault("alt")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = newJString("json"))
  if valid_589014 != nil:
    section.add "alt", valid_589014
  var valid_589015 = query.getOrDefault("includeGridData")
  valid_589015 = validateParameter(valid_589015, JBool, required = false, default = nil)
  if valid_589015 != nil:
    section.add "includeGridData", valid_589015
  var valid_589016 = query.getOrDefault("oauth_token")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "oauth_token", valid_589016
  var valid_589017 = query.getOrDefault("callback")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "callback", valid_589017
  var valid_589018 = query.getOrDefault("access_token")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "access_token", valid_589018
  var valid_589019 = query.getOrDefault("uploadType")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "uploadType", valid_589019
  var valid_589020 = query.getOrDefault("ranges")
  valid_589020 = validateParameter(valid_589020, JArray, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "ranges", valid_589020
  var valid_589021 = query.getOrDefault("key")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "key", valid_589021
  var valid_589022 = query.getOrDefault("$.xgafv")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = newJString("1"))
  if valid_589022 != nil:
    section.add "$.xgafv", valid_589022
  var valid_589023 = query.getOrDefault("prettyPrint")
  valid_589023 = validateParameter(valid_589023, JBool, required = false,
                                 default = newJBool(true))
  if valid_589023 != nil:
    section.add "prettyPrint", valid_589023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589024: Call_SheetsSpreadsheetsGet_588993; path: JsonNode;
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
  let valid = call_589024.validator(path, query, header, formData, body)
  let scheme = call_589024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589024.url(scheme.get, call_589024.host, call_589024.base,
                         call_589024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589024, url, valid)

proc call*(call_589025: Call_SheetsSpreadsheetsGet_588993; spreadsheetId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; includeGridData: bool = false; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          ranges: JsonNode = nil; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   includeGridData: bool
  ##                  : True if grid data should be returned.
  ## This parameter is ignored if a field mask was set in the request.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   ranges: JArray
  ##         : The ranges to retrieve from the spreadsheet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The spreadsheet to request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589026 = newJObject()
  var query_589027 = newJObject()
  add(query_589027, "upload_protocol", newJString(uploadProtocol))
  add(query_589027, "fields", newJString(fields))
  add(query_589027, "quotaUser", newJString(quotaUser))
  add(query_589027, "alt", newJString(alt))
  add(query_589027, "includeGridData", newJBool(includeGridData))
  add(query_589027, "oauth_token", newJString(oauthToken))
  add(query_589027, "callback", newJString(callback))
  add(query_589027, "access_token", newJString(accessToken))
  add(query_589027, "uploadType", newJString(uploadType))
  if ranges != nil:
    query_589027.add "ranges", ranges
  add(query_589027, "key", newJString(key))
  add(query_589027, "$.xgafv", newJString(Xgafv))
  add(path_589026, "spreadsheetId", newJString(spreadsheetId))
  add(query_589027, "prettyPrint", newJBool(prettyPrint))
  result = call_589025.call(path_589026, query_589027, nil, nil, nil)

var sheetsSpreadsheetsGet* = Call_SheetsSpreadsheetsGet_588993(
    name: "sheetsSpreadsheetsGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com", route: "/v4/spreadsheets/{spreadsheetId}",
    validator: validate_SheetsSpreadsheetsGet_588994, base: "/",
    url: url_SheetsSpreadsheetsGet_588995, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsDeveloperMetadataGet_589028 = ref object of OpenApiRestCall_588450
proc url_SheetsSpreadsheetsDeveloperMetadataGet_589030(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsDeveloperMetadataGet_589029(path: JsonNode;
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
  var valid_589031 = path.getOrDefault("metadataId")
  valid_589031 = validateParameter(valid_589031, JInt, required = true, default = nil)
  if valid_589031 != nil:
    section.add "metadataId", valid_589031
  var valid_589032 = path.getOrDefault("spreadsheetId")
  valid_589032 = validateParameter(valid_589032, JString, required = true,
                                 default = nil)
  if valid_589032 != nil:
    section.add "spreadsheetId", valid_589032
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589033 = query.getOrDefault("upload_protocol")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "upload_protocol", valid_589033
  var valid_589034 = query.getOrDefault("fields")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "fields", valid_589034
  var valid_589035 = query.getOrDefault("quotaUser")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "quotaUser", valid_589035
  var valid_589036 = query.getOrDefault("alt")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = newJString("json"))
  if valid_589036 != nil:
    section.add "alt", valid_589036
  var valid_589037 = query.getOrDefault("oauth_token")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "oauth_token", valid_589037
  var valid_589038 = query.getOrDefault("callback")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "callback", valid_589038
  var valid_589039 = query.getOrDefault("access_token")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "access_token", valid_589039
  var valid_589040 = query.getOrDefault("uploadType")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "uploadType", valid_589040
  var valid_589041 = query.getOrDefault("key")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "key", valid_589041
  var valid_589042 = query.getOrDefault("$.xgafv")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = newJString("1"))
  if valid_589042 != nil:
    section.add "$.xgafv", valid_589042
  var valid_589043 = query.getOrDefault("prettyPrint")
  valid_589043 = validateParameter(valid_589043, JBool, required = false,
                                 default = newJBool(true))
  if valid_589043 != nil:
    section.add "prettyPrint", valid_589043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589044: Call_SheetsSpreadsheetsDeveloperMetadataGet_589028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the developer metadata with the specified ID.
  ## The caller must specify the spreadsheet ID and the developer metadata's
  ## unique metadataId.
  ## 
  let valid = call_589044.validator(path, query, header, formData, body)
  let scheme = call_589044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589044.url(scheme.get, call_589044.host, call_589044.base,
                         call_589044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589044, url, valid)

proc call*(call_589045: Call_SheetsSpreadsheetsDeveloperMetadataGet_589028;
          metadataId: int; spreadsheetId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsDeveloperMetadataGet
  ## Returns the developer metadata with the specified ID.
  ## The caller must specify the spreadsheet ID and the developer metadata's
  ## unique metadataId.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   metadataId: int (required)
  ##             : The ID of the developer metadata to retrieve.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve metadata from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589046 = newJObject()
  var query_589047 = newJObject()
  add(query_589047, "upload_protocol", newJString(uploadProtocol))
  add(query_589047, "fields", newJString(fields))
  add(query_589047, "quotaUser", newJString(quotaUser))
  add(query_589047, "alt", newJString(alt))
  add(path_589046, "metadataId", newJInt(metadataId))
  add(query_589047, "oauth_token", newJString(oauthToken))
  add(query_589047, "callback", newJString(callback))
  add(query_589047, "access_token", newJString(accessToken))
  add(query_589047, "uploadType", newJString(uploadType))
  add(query_589047, "key", newJString(key))
  add(query_589047, "$.xgafv", newJString(Xgafv))
  add(path_589046, "spreadsheetId", newJString(spreadsheetId))
  add(query_589047, "prettyPrint", newJBool(prettyPrint))
  result = call_589045.call(path_589046, query_589047, nil, nil, nil)

var sheetsSpreadsheetsDeveloperMetadataGet* = Call_SheetsSpreadsheetsDeveloperMetadataGet_589028(
    name: "sheetsSpreadsheetsDeveloperMetadataGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/developerMetadata/{metadataId}",
    validator: validate_SheetsSpreadsheetsDeveloperMetadataGet_589029, base: "/",
    url: url_SheetsSpreadsheetsDeveloperMetadataGet_589030,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsDeveloperMetadataSearch_589048 = ref object of OpenApiRestCall_588450
proc url_SheetsSpreadsheetsDeveloperMetadataSearch_589050(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsDeveloperMetadataSearch_589049(path: JsonNode;
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
  var valid_589051 = path.getOrDefault("spreadsheetId")
  valid_589051 = validateParameter(valid_589051, JString, required = true,
                                 default = nil)
  if valid_589051 != nil:
    section.add "spreadsheetId", valid_589051
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589052 = query.getOrDefault("upload_protocol")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "upload_protocol", valid_589052
  var valid_589053 = query.getOrDefault("fields")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "fields", valid_589053
  var valid_589054 = query.getOrDefault("quotaUser")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "quotaUser", valid_589054
  var valid_589055 = query.getOrDefault("alt")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = newJString("json"))
  if valid_589055 != nil:
    section.add "alt", valid_589055
  var valid_589056 = query.getOrDefault("oauth_token")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "oauth_token", valid_589056
  var valid_589057 = query.getOrDefault("callback")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "callback", valid_589057
  var valid_589058 = query.getOrDefault("access_token")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "access_token", valid_589058
  var valid_589059 = query.getOrDefault("uploadType")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "uploadType", valid_589059
  var valid_589060 = query.getOrDefault("key")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "key", valid_589060
  var valid_589061 = query.getOrDefault("$.xgafv")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = newJString("1"))
  if valid_589061 != nil:
    section.add "$.xgafv", valid_589061
  var valid_589062 = query.getOrDefault("prettyPrint")
  valid_589062 = validateParameter(valid_589062, JBool, required = false,
                                 default = newJBool(true))
  if valid_589062 != nil:
    section.add "prettyPrint", valid_589062
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

proc call*(call_589064: Call_SheetsSpreadsheetsDeveloperMetadataSearch_589048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all developer metadata matching the specified DataFilter.
  ## If the provided DataFilter represents a DeveloperMetadataLookup object,
  ## this will return all DeveloperMetadata entries selected by it. If the
  ## DataFilter represents a location in a spreadsheet, this will return all
  ## developer metadata associated with locations intersecting that region.
  ## 
  let valid = call_589064.validator(path, query, header, formData, body)
  let scheme = call_589064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589064.url(scheme.get, call_589064.host, call_589064.base,
                         call_589064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589064, url, valid)

proc call*(call_589065: Call_SheetsSpreadsheetsDeveloperMetadataSearch_589048;
          spreadsheetId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsDeveloperMetadataSearch
  ## Returns all developer metadata matching the specified DataFilter.
  ## If the provided DataFilter represents a DeveloperMetadataLookup object,
  ## this will return all DeveloperMetadata entries selected by it. If the
  ## DataFilter represents a location in a spreadsheet, this will return all
  ## developer metadata associated with locations intersecting that region.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve metadata from.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589066 = newJObject()
  var query_589067 = newJObject()
  var body_589068 = newJObject()
  add(query_589067, "upload_protocol", newJString(uploadProtocol))
  add(query_589067, "fields", newJString(fields))
  add(query_589067, "quotaUser", newJString(quotaUser))
  add(query_589067, "alt", newJString(alt))
  add(query_589067, "oauth_token", newJString(oauthToken))
  add(query_589067, "callback", newJString(callback))
  add(query_589067, "access_token", newJString(accessToken))
  add(query_589067, "uploadType", newJString(uploadType))
  add(query_589067, "key", newJString(key))
  add(query_589067, "$.xgafv", newJString(Xgafv))
  add(path_589066, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_589068 = body
  add(query_589067, "prettyPrint", newJBool(prettyPrint))
  result = call_589065.call(path_589066, query_589067, nil, nil, body_589068)

var sheetsSpreadsheetsDeveloperMetadataSearch* = Call_SheetsSpreadsheetsDeveloperMetadataSearch_589048(
    name: "sheetsSpreadsheetsDeveloperMetadataSearch", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/developerMetadata:search",
    validator: validate_SheetsSpreadsheetsDeveloperMetadataSearch_589049,
    base: "/", url: url_SheetsSpreadsheetsDeveloperMetadataSearch_589050,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsSheetsCopyTo_589069 = ref object of OpenApiRestCall_588450
proc url_SheetsSpreadsheetsSheetsCopyTo_589071(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsSheetsCopyTo_589070(path: JsonNode;
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
  var valid_589072 = path.getOrDefault("sheetId")
  valid_589072 = validateParameter(valid_589072, JInt, required = true, default = nil)
  if valid_589072 != nil:
    section.add "sheetId", valid_589072
  var valid_589073 = path.getOrDefault("spreadsheetId")
  valid_589073 = validateParameter(valid_589073, JString, required = true,
                                 default = nil)
  if valid_589073 != nil:
    section.add "spreadsheetId", valid_589073
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589074 = query.getOrDefault("upload_protocol")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "upload_protocol", valid_589074
  var valid_589075 = query.getOrDefault("fields")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "fields", valid_589075
  var valid_589076 = query.getOrDefault("quotaUser")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "quotaUser", valid_589076
  var valid_589077 = query.getOrDefault("alt")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = newJString("json"))
  if valid_589077 != nil:
    section.add "alt", valid_589077
  var valid_589078 = query.getOrDefault("oauth_token")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "oauth_token", valid_589078
  var valid_589079 = query.getOrDefault("callback")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "callback", valid_589079
  var valid_589080 = query.getOrDefault("access_token")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "access_token", valid_589080
  var valid_589081 = query.getOrDefault("uploadType")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "uploadType", valid_589081
  var valid_589082 = query.getOrDefault("key")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "key", valid_589082
  var valid_589083 = query.getOrDefault("$.xgafv")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = newJString("1"))
  if valid_589083 != nil:
    section.add "$.xgafv", valid_589083
  var valid_589084 = query.getOrDefault("prettyPrint")
  valid_589084 = validateParameter(valid_589084, JBool, required = false,
                                 default = newJBool(true))
  if valid_589084 != nil:
    section.add "prettyPrint", valid_589084
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

proc call*(call_589086: Call_SheetsSpreadsheetsSheetsCopyTo_589069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies a single sheet from a spreadsheet to another spreadsheet.
  ## Returns the properties of the newly created sheet.
  ## 
  let valid = call_589086.validator(path, query, header, formData, body)
  let scheme = call_589086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589086.url(scheme.get, call_589086.host, call_589086.base,
                         call_589086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589086, url, valid)

proc call*(call_589087: Call_SheetsSpreadsheetsSheetsCopyTo_589069; sheetId: int;
          spreadsheetId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsSheetsCopyTo
  ## Copies a single sheet from a spreadsheet to another spreadsheet.
  ## Returns the properties of the newly created sheet.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   sheetId: int (required)
  ##          : The ID of the sheet to copy.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet containing the sheet to copy.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589088 = newJObject()
  var query_589089 = newJObject()
  var body_589090 = newJObject()
  add(query_589089, "upload_protocol", newJString(uploadProtocol))
  add(query_589089, "fields", newJString(fields))
  add(query_589089, "quotaUser", newJString(quotaUser))
  add(query_589089, "alt", newJString(alt))
  add(query_589089, "oauth_token", newJString(oauthToken))
  add(query_589089, "callback", newJString(callback))
  add(query_589089, "access_token", newJString(accessToken))
  add(query_589089, "uploadType", newJString(uploadType))
  add(query_589089, "key", newJString(key))
  add(query_589089, "$.xgafv", newJString(Xgafv))
  add(path_589088, "sheetId", newJInt(sheetId))
  add(path_589088, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_589090 = body
  add(query_589089, "prettyPrint", newJBool(prettyPrint))
  result = call_589087.call(path_589088, query_589089, nil, nil, body_589090)

var sheetsSpreadsheetsSheetsCopyTo* = Call_SheetsSpreadsheetsSheetsCopyTo_589069(
    name: "sheetsSpreadsheetsSheetsCopyTo", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/sheets/{sheetId}:copyTo",
    validator: validate_SheetsSpreadsheetsSheetsCopyTo_589070, base: "/",
    url: url_SheetsSpreadsheetsSheetsCopyTo_589071, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesUpdate_589114 = ref object of OpenApiRestCall_588450
proc url_SheetsSpreadsheetsValuesUpdate_589116(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesUpdate_589115(path: JsonNode;
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
  var valid_589117 = path.getOrDefault("spreadsheetId")
  valid_589117 = validateParameter(valid_589117, JString, required = true,
                                 default = nil)
  if valid_589117 != nil:
    section.add "spreadsheetId", valid_589117
  var valid_589118 = path.getOrDefault("range")
  valid_589118 = validateParameter(valid_589118, JString, required = true,
                                 default = nil)
  if valid_589118 != nil:
    section.add "range", valid_589118
  result.add "path", section
  ## parameters in `query` object:
  ##   responseValueRenderOption: JString
  ##                            : Determines how values in the response should be rendered.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   responseDateTimeRenderOption: JString
  ##                               : Determines how dates, times, and durations in the response should be
  ## rendered. This is ignored if response_value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is
  ## DateTimeRenderOption.SERIAL_NUMBER.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   includeValuesInResponse: JBool
  ##                          : Determines if the update response should include the values
  ## of the cells that were updated. By default, responses
  ## do not include the updated values.
  ## If the range to write was larger than than the range actually written,
  ## the response will include all values in the requested range (excluding
  ## trailing empty rows and columns).
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   valueInputOption: JString
  ##                   : How the input data should be interpreted.
  section = newJObject()
  var valid_589119 = query.getOrDefault("responseValueRenderOption")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_589119 != nil:
    section.add "responseValueRenderOption", valid_589119
  var valid_589120 = query.getOrDefault("upload_protocol")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "upload_protocol", valid_589120
  var valid_589121 = query.getOrDefault("fields")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "fields", valid_589121
  var valid_589122 = query.getOrDefault("quotaUser")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "quotaUser", valid_589122
  var valid_589123 = query.getOrDefault("alt")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = newJString("json"))
  if valid_589123 != nil:
    section.add "alt", valid_589123
  var valid_589124 = query.getOrDefault("responseDateTimeRenderOption")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_589124 != nil:
    section.add "responseDateTimeRenderOption", valid_589124
  var valid_589125 = query.getOrDefault("oauth_token")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "oauth_token", valid_589125
  var valid_589126 = query.getOrDefault("callback")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "callback", valid_589126
  var valid_589127 = query.getOrDefault("access_token")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "access_token", valid_589127
  var valid_589128 = query.getOrDefault("uploadType")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "uploadType", valid_589128
  var valid_589129 = query.getOrDefault("includeValuesInResponse")
  valid_589129 = validateParameter(valid_589129, JBool, required = false, default = nil)
  if valid_589129 != nil:
    section.add "includeValuesInResponse", valid_589129
  var valid_589130 = query.getOrDefault("key")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "key", valid_589130
  var valid_589131 = query.getOrDefault("$.xgafv")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = newJString("1"))
  if valid_589131 != nil:
    section.add "$.xgafv", valid_589131
  var valid_589132 = query.getOrDefault("prettyPrint")
  valid_589132 = validateParameter(valid_589132, JBool, required = false,
                                 default = newJBool(true))
  if valid_589132 != nil:
    section.add "prettyPrint", valid_589132
  var valid_589133 = query.getOrDefault("valueInputOption")
  valid_589133 = validateParameter(valid_589133, JString, required = false, default = newJString(
      "INPUT_VALUE_OPTION_UNSPECIFIED"))
  if valid_589133 != nil:
    section.add "valueInputOption", valid_589133
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

proc call*(call_589135: Call_SheetsSpreadsheetsValuesUpdate_589114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets values in a range of a spreadsheet.
  ## The caller must specify the spreadsheet ID, range, and
  ## a valueInputOption.
  ## 
  let valid = call_589135.validator(path, query, header, formData, body)
  let scheme = call_589135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589135.url(scheme.get, call_589135.host, call_589135.base,
                         call_589135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589135, url, valid)

proc call*(call_589136: Call_SheetsSpreadsheetsValuesUpdate_589114;
          spreadsheetId: string; range: string;
          responseValueRenderOption: string = "FORMATTED_VALUE";
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json";
          responseDateTimeRenderOption: string = "SERIAL_NUMBER";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; includeValuesInResponse: bool = false;
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true;
          valueInputOption: string = "INPUT_VALUE_OPTION_UNSPECIFIED"): Recallable =
  ## sheetsSpreadsheetsValuesUpdate
  ## Sets values in a range of a spreadsheet.
  ## The caller must specify the spreadsheet ID, range, and
  ## a valueInputOption.
  ##   responseValueRenderOption: string
  ##                            : Determines how values in the response should be rendered.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   responseDateTimeRenderOption: string
  ##                               : Determines how dates, times, and durations in the response should be
  ## rendered. This is ignored if response_value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is
  ## DateTimeRenderOption.SERIAL_NUMBER.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   includeValuesInResponse: bool
  ##                          : Determines if the update response should include the values
  ## of the cells that were updated. By default, responses
  ## do not include the updated values.
  ## If the range to write was larger than than the range actually written,
  ## the response will include all values in the requested range (excluding
  ## trailing empty rows and columns).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   valueInputOption: string
  ##                   : How the input data should be interpreted.
  ##   range: string (required)
  ##        : The A1 notation of the values to update.
  var path_589137 = newJObject()
  var query_589138 = newJObject()
  var body_589139 = newJObject()
  add(query_589138, "responseValueRenderOption",
      newJString(responseValueRenderOption))
  add(query_589138, "upload_protocol", newJString(uploadProtocol))
  add(query_589138, "fields", newJString(fields))
  add(query_589138, "quotaUser", newJString(quotaUser))
  add(query_589138, "alt", newJString(alt))
  add(query_589138, "responseDateTimeRenderOption",
      newJString(responseDateTimeRenderOption))
  add(query_589138, "oauth_token", newJString(oauthToken))
  add(query_589138, "callback", newJString(callback))
  add(query_589138, "access_token", newJString(accessToken))
  add(query_589138, "uploadType", newJString(uploadType))
  add(query_589138, "includeValuesInResponse", newJBool(includeValuesInResponse))
  add(query_589138, "key", newJString(key))
  add(query_589138, "$.xgafv", newJString(Xgafv))
  add(path_589137, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_589139 = body
  add(query_589138, "prettyPrint", newJBool(prettyPrint))
  add(query_589138, "valueInputOption", newJString(valueInputOption))
  add(path_589137, "range", newJString(range))
  result = call_589136.call(path_589137, query_589138, nil, nil, body_589139)

var sheetsSpreadsheetsValuesUpdate* = Call_SheetsSpreadsheetsValuesUpdate_589114(
    name: "sheetsSpreadsheetsValuesUpdate", meth: HttpMethod.HttpPut,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}",
    validator: validate_SheetsSpreadsheetsValuesUpdate_589115, base: "/",
    url: url_SheetsSpreadsheetsValuesUpdate_589116, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesGet_589091 = ref object of OpenApiRestCall_588450
proc url_SheetsSpreadsheetsValuesGet_589093(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesGet_589092(path: JsonNode; query: JsonNode;
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
  var valid_589094 = path.getOrDefault("spreadsheetId")
  valid_589094 = validateParameter(valid_589094, JString, required = true,
                                 default = nil)
  if valid_589094 != nil:
    section.add "spreadsheetId", valid_589094
  var valid_589095 = path.getOrDefault("range")
  valid_589095 = validateParameter(valid_589095, JString, required = true,
                                 default = nil)
  if valid_589095 != nil:
    section.add "range", valid_589095
  result.add "path", section
  ## parameters in `query` object:
  ##   majorDimension: JString
  ##                 : The major dimension that results should use.
  ## 
  ## For example, if the spreadsheet data is: `A1=1,B1=2,A2=3,B2=4`,
  ## then requesting `range=A1:B2,majorDimension=ROWS` will return
  ## `[[1,2],[3,4]]`,
  ## whereas requesting `range=A1:B2,majorDimension=COLUMNS` will return
  ## `[[1,3],[2,4]]`.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   valueRenderOption: JString
  ##                    : How values should be represented in the output.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   dateTimeRenderOption: JString
  ##                       : How dates, times, and durations should be represented in the output.
  ## This is ignored if value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589096 = query.getOrDefault("majorDimension")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = newJString("DIMENSION_UNSPECIFIED"))
  if valid_589096 != nil:
    section.add "majorDimension", valid_589096
  var valid_589097 = query.getOrDefault("upload_protocol")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "upload_protocol", valid_589097
  var valid_589098 = query.getOrDefault("fields")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "fields", valid_589098
  var valid_589099 = query.getOrDefault("quotaUser")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "quotaUser", valid_589099
  var valid_589100 = query.getOrDefault("alt")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = newJString("json"))
  if valid_589100 != nil:
    section.add "alt", valid_589100
  var valid_589101 = query.getOrDefault("valueRenderOption")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_589101 != nil:
    section.add "valueRenderOption", valid_589101
  var valid_589102 = query.getOrDefault("oauth_token")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "oauth_token", valid_589102
  var valid_589103 = query.getOrDefault("callback")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "callback", valid_589103
  var valid_589104 = query.getOrDefault("access_token")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "access_token", valid_589104
  var valid_589105 = query.getOrDefault("uploadType")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "uploadType", valid_589105
  var valid_589106 = query.getOrDefault("key")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "key", valid_589106
  var valid_589107 = query.getOrDefault("$.xgafv")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = newJString("1"))
  if valid_589107 != nil:
    section.add "$.xgafv", valid_589107
  var valid_589108 = query.getOrDefault("dateTimeRenderOption")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_589108 != nil:
    section.add "dateTimeRenderOption", valid_589108
  var valid_589109 = query.getOrDefault("prettyPrint")
  valid_589109 = validateParameter(valid_589109, JBool, required = false,
                                 default = newJBool(true))
  if valid_589109 != nil:
    section.add "prettyPrint", valid_589109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589110: Call_SheetsSpreadsheetsValuesGet_589091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a range of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and a range.
  ## 
  let valid = call_589110.validator(path, query, header, formData, body)
  let scheme = call_589110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589110.url(scheme.get, call_589110.host, call_589110.base,
                         call_589110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589110, url, valid)

proc call*(call_589111: Call_SheetsSpreadsheetsValuesGet_589091;
          spreadsheetId: string; range: string;
          majorDimension: string = "DIMENSION_UNSPECIFIED";
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; valueRenderOption: string = "FORMATTED_VALUE";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          dateTimeRenderOption: string = "SERIAL_NUMBER"; prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsValuesGet
  ## Returns a range of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and a range.
  ##   majorDimension: string
  ##                 : The major dimension that results should use.
  ## 
  ## For example, if the spreadsheet data is: `A1=1,B1=2,A2=3,B2=4`,
  ## then requesting `range=A1:B2,majorDimension=ROWS` will return
  ## `[[1,2],[3,4]]`,
  ## whereas requesting `range=A1:B2,majorDimension=COLUMNS` will return
  ## `[[1,3],[2,4]]`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   valueRenderOption: string
  ##                    : How values should be represented in the output.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   dateTimeRenderOption: string
  ##                       : How dates, times, and durations should be represented in the output.
  ## This is ignored if value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve data from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   range: string (required)
  ##        : The A1 notation of the values to retrieve.
  var path_589112 = newJObject()
  var query_589113 = newJObject()
  add(query_589113, "majorDimension", newJString(majorDimension))
  add(query_589113, "upload_protocol", newJString(uploadProtocol))
  add(query_589113, "fields", newJString(fields))
  add(query_589113, "quotaUser", newJString(quotaUser))
  add(query_589113, "alt", newJString(alt))
  add(query_589113, "valueRenderOption", newJString(valueRenderOption))
  add(query_589113, "oauth_token", newJString(oauthToken))
  add(query_589113, "callback", newJString(callback))
  add(query_589113, "access_token", newJString(accessToken))
  add(query_589113, "uploadType", newJString(uploadType))
  add(query_589113, "key", newJString(key))
  add(query_589113, "$.xgafv", newJString(Xgafv))
  add(query_589113, "dateTimeRenderOption", newJString(dateTimeRenderOption))
  add(path_589112, "spreadsheetId", newJString(spreadsheetId))
  add(query_589113, "prettyPrint", newJBool(prettyPrint))
  add(path_589112, "range", newJString(range))
  result = call_589111.call(path_589112, query_589113, nil, nil, nil)

var sheetsSpreadsheetsValuesGet* = Call_SheetsSpreadsheetsValuesGet_589091(
    name: "sheetsSpreadsheetsValuesGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}",
    validator: validate_SheetsSpreadsheetsValuesGet_589092, base: "/",
    url: url_SheetsSpreadsheetsValuesGet_589093, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesAppend_589140 = ref object of OpenApiRestCall_588450
proc url_SheetsSpreadsheetsValuesAppend_589142(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesAppend_589141(path: JsonNode;
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
  var valid_589143 = path.getOrDefault("spreadsheetId")
  valid_589143 = validateParameter(valid_589143, JString, required = true,
                                 default = nil)
  if valid_589143 != nil:
    section.add "spreadsheetId", valid_589143
  var valid_589144 = path.getOrDefault("range")
  valid_589144 = validateParameter(valid_589144, JString, required = true,
                                 default = nil)
  if valid_589144 != nil:
    section.add "range", valid_589144
  result.add "path", section
  ## parameters in `query` object:
  ##   responseValueRenderOption: JString
  ##                            : Determines how values in the response should be rendered.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   responseDateTimeRenderOption: JString
  ##                               : Determines how dates, times, and durations in the response should be
  ## rendered. This is ignored if response_value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   includeValuesInResponse: JBool
  ##                          : Determines if the update response should include the values
  ## of the cells that were appended. By default, responses
  ## do not include the updated values.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   insertDataOption: JString
  ##                   : How the input data should be inserted.
  ##   valueInputOption: JString
  ##                   : How the input data should be interpreted.
  section = newJObject()
  var valid_589145 = query.getOrDefault("responseValueRenderOption")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_589145 != nil:
    section.add "responseValueRenderOption", valid_589145
  var valid_589146 = query.getOrDefault("upload_protocol")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "upload_protocol", valid_589146
  var valid_589147 = query.getOrDefault("fields")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "fields", valid_589147
  var valid_589148 = query.getOrDefault("quotaUser")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "quotaUser", valid_589148
  var valid_589149 = query.getOrDefault("alt")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = newJString("json"))
  if valid_589149 != nil:
    section.add "alt", valid_589149
  var valid_589150 = query.getOrDefault("responseDateTimeRenderOption")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_589150 != nil:
    section.add "responseDateTimeRenderOption", valid_589150
  var valid_589151 = query.getOrDefault("oauth_token")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "oauth_token", valid_589151
  var valid_589152 = query.getOrDefault("callback")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "callback", valid_589152
  var valid_589153 = query.getOrDefault("access_token")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "access_token", valid_589153
  var valid_589154 = query.getOrDefault("uploadType")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "uploadType", valid_589154
  var valid_589155 = query.getOrDefault("includeValuesInResponse")
  valid_589155 = validateParameter(valid_589155, JBool, required = false, default = nil)
  if valid_589155 != nil:
    section.add "includeValuesInResponse", valid_589155
  var valid_589156 = query.getOrDefault("key")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "key", valid_589156
  var valid_589157 = query.getOrDefault("$.xgafv")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = newJString("1"))
  if valid_589157 != nil:
    section.add "$.xgafv", valid_589157
  var valid_589158 = query.getOrDefault("prettyPrint")
  valid_589158 = validateParameter(valid_589158, JBool, required = false,
                                 default = newJBool(true))
  if valid_589158 != nil:
    section.add "prettyPrint", valid_589158
  var valid_589159 = query.getOrDefault("insertDataOption")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = newJString("OVERWRITE"))
  if valid_589159 != nil:
    section.add "insertDataOption", valid_589159
  var valid_589160 = query.getOrDefault("valueInputOption")
  valid_589160 = validateParameter(valid_589160, JString, required = false, default = newJString(
      "INPUT_VALUE_OPTION_UNSPECIFIED"))
  if valid_589160 != nil:
    section.add "valueInputOption", valid_589160
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

proc call*(call_589162: Call_SheetsSpreadsheetsValuesAppend_589140; path: JsonNode;
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
  let valid = call_589162.validator(path, query, header, formData, body)
  let scheme = call_589162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589162.url(scheme.get, call_589162.host, call_589162.base,
                         call_589162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589162, url, valid)

proc call*(call_589163: Call_SheetsSpreadsheetsValuesAppend_589140;
          spreadsheetId: string; range: string;
          responseValueRenderOption: string = "FORMATTED_VALUE";
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json";
          responseDateTimeRenderOption: string = "SERIAL_NUMBER";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; includeValuesInResponse: bool = false;
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; insertDataOption: string = "OVERWRITE";
          valueInputOption: string = "INPUT_VALUE_OPTION_UNSPECIFIED"): Recallable =
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
  ##   responseValueRenderOption: string
  ##                            : Determines how values in the response should be rendered.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   responseDateTimeRenderOption: string
  ##                               : Determines how dates, times, and durations in the response should be
  ## rendered. This is ignored if response_value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   includeValuesInResponse: bool
  ##                          : Determines if the update response should include the values
  ## of the cells that were appended. By default, responses
  ## do not include the updated values.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   insertDataOption: string
  ##                   : How the input data should be inserted.
  ##   valueInputOption: string
  ##                   : How the input data should be interpreted.
  ##   range: string (required)
  ##        : The A1 notation of a range to search for a logical table of data.
  ## Values will be appended after the last row of the table.
  var path_589164 = newJObject()
  var query_589165 = newJObject()
  var body_589166 = newJObject()
  add(query_589165, "responseValueRenderOption",
      newJString(responseValueRenderOption))
  add(query_589165, "upload_protocol", newJString(uploadProtocol))
  add(query_589165, "fields", newJString(fields))
  add(query_589165, "quotaUser", newJString(quotaUser))
  add(query_589165, "alt", newJString(alt))
  add(query_589165, "responseDateTimeRenderOption",
      newJString(responseDateTimeRenderOption))
  add(query_589165, "oauth_token", newJString(oauthToken))
  add(query_589165, "callback", newJString(callback))
  add(query_589165, "access_token", newJString(accessToken))
  add(query_589165, "uploadType", newJString(uploadType))
  add(query_589165, "includeValuesInResponse", newJBool(includeValuesInResponse))
  add(query_589165, "key", newJString(key))
  add(query_589165, "$.xgafv", newJString(Xgafv))
  add(path_589164, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_589166 = body
  add(query_589165, "prettyPrint", newJBool(prettyPrint))
  add(query_589165, "insertDataOption", newJString(insertDataOption))
  add(query_589165, "valueInputOption", newJString(valueInputOption))
  add(path_589164, "range", newJString(range))
  result = call_589163.call(path_589164, query_589165, nil, nil, body_589166)

var sheetsSpreadsheetsValuesAppend* = Call_SheetsSpreadsheetsValuesAppend_589140(
    name: "sheetsSpreadsheetsValuesAppend", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}:append",
    validator: validate_SheetsSpreadsheetsValuesAppend_589141, base: "/",
    url: url_SheetsSpreadsheetsValuesAppend_589142, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesClear_589167 = ref object of OpenApiRestCall_588450
proc url_SheetsSpreadsheetsValuesClear_589169(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesClear_589168(path: JsonNode; query: JsonNode;
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
  var valid_589170 = path.getOrDefault("spreadsheetId")
  valid_589170 = validateParameter(valid_589170, JString, required = true,
                                 default = nil)
  if valid_589170 != nil:
    section.add "spreadsheetId", valid_589170
  var valid_589171 = path.getOrDefault("range")
  valid_589171 = validateParameter(valid_589171, JString, required = true,
                                 default = nil)
  if valid_589171 != nil:
    section.add "range", valid_589171
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589172 = query.getOrDefault("upload_protocol")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "upload_protocol", valid_589172
  var valid_589173 = query.getOrDefault("fields")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "fields", valid_589173
  var valid_589174 = query.getOrDefault("quotaUser")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "quotaUser", valid_589174
  var valid_589175 = query.getOrDefault("alt")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = newJString("json"))
  if valid_589175 != nil:
    section.add "alt", valid_589175
  var valid_589176 = query.getOrDefault("oauth_token")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "oauth_token", valid_589176
  var valid_589177 = query.getOrDefault("callback")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "callback", valid_589177
  var valid_589178 = query.getOrDefault("access_token")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "access_token", valid_589178
  var valid_589179 = query.getOrDefault("uploadType")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "uploadType", valid_589179
  var valid_589180 = query.getOrDefault("key")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "key", valid_589180
  var valid_589181 = query.getOrDefault("$.xgafv")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = newJString("1"))
  if valid_589181 != nil:
    section.add "$.xgafv", valid_589181
  var valid_589182 = query.getOrDefault("prettyPrint")
  valid_589182 = validateParameter(valid_589182, JBool, required = false,
                                 default = newJBool(true))
  if valid_589182 != nil:
    section.add "prettyPrint", valid_589182
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

proc call*(call_589184: Call_SheetsSpreadsheetsValuesClear_589167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clears values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and range.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ## 
  let valid = call_589184.validator(path, query, header, formData, body)
  let scheme = call_589184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589184.url(scheme.get, call_589184.host, call_589184.base,
                         call_589184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589184, url, valid)

proc call*(call_589185: Call_SheetsSpreadsheetsValuesClear_589167;
          spreadsheetId: string; range: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsValuesClear
  ## Clears values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and range.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   range: string (required)
  ##        : The A1 notation of the values to clear.
  var path_589186 = newJObject()
  var query_589187 = newJObject()
  var body_589188 = newJObject()
  add(query_589187, "upload_protocol", newJString(uploadProtocol))
  add(query_589187, "fields", newJString(fields))
  add(query_589187, "quotaUser", newJString(quotaUser))
  add(query_589187, "alt", newJString(alt))
  add(query_589187, "oauth_token", newJString(oauthToken))
  add(query_589187, "callback", newJString(callback))
  add(query_589187, "access_token", newJString(accessToken))
  add(query_589187, "uploadType", newJString(uploadType))
  add(query_589187, "key", newJString(key))
  add(query_589187, "$.xgafv", newJString(Xgafv))
  add(path_589186, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_589188 = body
  add(query_589187, "prettyPrint", newJBool(prettyPrint))
  add(path_589186, "range", newJString(range))
  result = call_589185.call(path_589186, query_589187, nil, nil, body_589188)

var sheetsSpreadsheetsValuesClear* = Call_SheetsSpreadsheetsValuesClear_589167(
    name: "sheetsSpreadsheetsValuesClear", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}:clear",
    validator: validate_SheetsSpreadsheetsValuesClear_589168, base: "/",
    url: url_SheetsSpreadsheetsValuesClear_589169, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchClear_589189 = ref object of OpenApiRestCall_588450
proc url_SheetsSpreadsheetsValuesBatchClear_589191(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesBatchClear_589190(path: JsonNode;
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
  var valid_589192 = path.getOrDefault("spreadsheetId")
  valid_589192 = validateParameter(valid_589192, JString, required = true,
                                 default = nil)
  if valid_589192 != nil:
    section.add "spreadsheetId", valid_589192
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589193 = query.getOrDefault("upload_protocol")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "upload_protocol", valid_589193
  var valid_589194 = query.getOrDefault("fields")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "fields", valid_589194
  var valid_589195 = query.getOrDefault("quotaUser")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "quotaUser", valid_589195
  var valid_589196 = query.getOrDefault("alt")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = newJString("json"))
  if valid_589196 != nil:
    section.add "alt", valid_589196
  var valid_589197 = query.getOrDefault("oauth_token")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "oauth_token", valid_589197
  var valid_589198 = query.getOrDefault("callback")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "callback", valid_589198
  var valid_589199 = query.getOrDefault("access_token")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "access_token", valid_589199
  var valid_589200 = query.getOrDefault("uploadType")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "uploadType", valid_589200
  var valid_589201 = query.getOrDefault("key")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "key", valid_589201
  var valid_589202 = query.getOrDefault("$.xgafv")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = newJString("1"))
  if valid_589202 != nil:
    section.add "$.xgafv", valid_589202
  var valid_589203 = query.getOrDefault("prettyPrint")
  valid_589203 = validateParameter(valid_589203, JBool, required = false,
                                 default = newJBool(true))
  if valid_589203 != nil:
    section.add "prettyPrint", valid_589203
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

proc call*(call_589205: Call_SheetsSpreadsheetsValuesBatchClear_589189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ## 
  let valid = call_589205.validator(path, query, header, formData, body)
  let scheme = call_589205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589205.url(scheme.get, call_589205.host, call_589205.base,
                         call_589205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589205, url, valid)

proc call*(call_589206: Call_SheetsSpreadsheetsValuesBatchClear_589189;
          spreadsheetId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsValuesBatchClear
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589207 = newJObject()
  var query_589208 = newJObject()
  var body_589209 = newJObject()
  add(query_589208, "upload_protocol", newJString(uploadProtocol))
  add(query_589208, "fields", newJString(fields))
  add(query_589208, "quotaUser", newJString(quotaUser))
  add(query_589208, "alt", newJString(alt))
  add(query_589208, "oauth_token", newJString(oauthToken))
  add(query_589208, "callback", newJString(callback))
  add(query_589208, "access_token", newJString(accessToken))
  add(query_589208, "uploadType", newJString(uploadType))
  add(query_589208, "key", newJString(key))
  add(query_589208, "$.xgafv", newJString(Xgafv))
  add(path_589207, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_589209 = body
  add(query_589208, "prettyPrint", newJBool(prettyPrint))
  result = call_589206.call(path_589207, query_589208, nil, nil, body_589209)

var sheetsSpreadsheetsValuesBatchClear* = Call_SheetsSpreadsheetsValuesBatchClear_589189(
    name: "sheetsSpreadsheetsValuesBatchClear", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchClear",
    validator: validate_SheetsSpreadsheetsValuesBatchClear_589190, base: "/",
    url: url_SheetsSpreadsheetsValuesBatchClear_589191, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_589210 = ref object of OpenApiRestCall_588450
proc url_SheetsSpreadsheetsValuesBatchClearByDataFilter_589212(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesBatchClearByDataFilter_589211(
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
  var valid_589213 = path.getOrDefault("spreadsheetId")
  valid_589213 = validateParameter(valid_589213, JString, required = true,
                                 default = nil)
  if valid_589213 != nil:
    section.add "spreadsheetId", valid_589213
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589214 = query.getOrDefault("upload_protocol")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "upload_protocol", valid_589214
  var valid_589215 = query.getOrDefault("fields")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "fields", valid_589215
  var valid_589216 = query.getOrDefault("quotaUser")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "quotaUser", valid_589216
  var valid_589217 = query.getOrDefault("alt")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = newJString("json"))
  if valid_589217 != nil:
    section.add "alt", valid_589217
  var valid_589218 = query.getOrDefault("oauth_token")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "oauth_token", valid_589218
  var valid_589219 = query.getOrDefault("callback")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "callback", valid_589219
  var valid_589220 = query.getOrDefault("access_token")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "access_token", valid_589220
  var valid_589221 = query.getOrDefault("uploadType")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "uploadType", valid_589221
  var valid_589222 = query.getOrDefault("key")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "key", valid_589222
  var valid_589223 = query.getOrDefault("$.xgafv")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = newJString("1"))
  if valid_589223 != nil:
    section.add "$.xgafv", valid_589223
  var valid_589224 = query.getOrDefault("prettyPrint")
  valid_589224 = validateParameter(valid_589224, JBool, required = false,
                                 default = newJBool(true))
  if valid_589224 != nil:
    section.add "prettyPrint", valid_589224
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

proc call*(call_589226: Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_589210;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters. Ranges matching any of the specified data
  ## filters will be cleared.  Only values are cleared -- all other properties
  ## of the cell (such as formatting, data validation, etc..) are kept.
  ## 
  let valid = call_589226.validator(path, query, header, formData, body)
  let scheme = call_589226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589226.url(scheme.get, call_589226.host, call_589226.base,
                         call_589226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589226, url, valid)

proc call*(call_589227: Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_589210;
          spreadsheetId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsValuesBatchClearByDataFilter
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters. Ranges matching any of the specified data
  ## filters will be cleared.  Only values are cleared -- all other properties
  ## of the cell (such as formatting, data validation, etc..) are kept.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589228 = newJObject()
  var query_589229 = newJObject()
  var body_589230 = newJObject()
  add(query_589229, "upload_protocol", newJString(uploadProtocol))
  add(query_589229, "fields", newJString(fields))
  add(query_589229, "quotaUser", newJString(quotaUser))
  add(query_589229, "alt", newJString(alt))
  add(query_589229, "oauth_token", newJString(oauthToken))
  add(query_589229, "callback", newJString(callback))
  add(query_589229, "access_token", newJString(accessToken))
  add(query_589229, "uploadType", newJString(uploadType))
  add(query_589229, "key", newJString(key))
  add(query_589229, "$.xgafv", newJString(Xgafv))
  add(path_589228, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_589230 = body
  add(query_589229, "prettyPrint", newJBool(prettyPrint))
  result = call_589227.call(path_589228, query_589229, nil, nil, body_589230)

var sheetsSpreadsheetsValuesBatchClearByDataFilter* = Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_589210(
    name: "sheetsSpreadsheetsValuesBatchClearByDataFilter",
    meth: HttpMethod.HttpPost, host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchClearByDataFilter",
    validator: validate_SheetsSpreadsheetsValuesBatchClearByDataFilter_589211,
    base: "/", url: url_SheetsSpreadsheetsValuesBatchClearByDataFilter_589212,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchGet_589231 = ref object of OpenApiRestCall_588450
proc url_SheetsSpreadsheetsValuesBatchGet_589233(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesBatchGet_589232(path: JsonNode;
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
  var valid_589234 = path.getOrDefault("spreadsheetId")
  valid_589234 = validateParameter(valid_589234, JString, required = true,
                                 default = nil)
  if valid_589234 != nil:
    section.add "spreadsheetId", valid_589234
  result.add "path", section
  ## parameters in `query` object:
  ##   majorDimension: JString
  ##                 : The major dimension that results should use.
  ## 
  ## For example, if the spreadsheet data is: `A1=1,B1=2,A2=3,B2=4`,
  ## then requesting `range=A1:B2,majorDimension=ROWS` will return
  ## `[[1,2],[3,4]]`,
  ## whereas requesting `range=A1:B2,majorDimension=COLUMNS` will return
  ## `[[1,3],[2,4]]`.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   valueRenderOption: JString
  ##                    : How values should be represented in the output.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   ranges: JArray
  ##         : The A1 notation of the values to retrieve.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   dateTimeRenderOption: JString
  ##                       : How dates, times, and durations should be represented in the output.
  ## This is ignored if value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589235 = query.getOrDefault("majorDimension")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = newJString("DIMENSION_UNSPECIFIED"))
  if valid_589235 != nil:
    section.add "majorDimension", valid_589235
  var valid_589236 = query.getOrDefault("upload_protocol")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "upload_protocol", valid_589236
  var valid_589237 = query.getOrDefault("fields")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "fields", valid_589237
  var valid_589238 = query.getOrDefault("quotaUser")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "quotaUser", valid_589238
  var valid_589239 = query.getOrDefault("alt")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = newJString("json"))
  if valid_589239 != nil:
    section.add "alt", valid_589239
  var valid_589240 = query.getOrDefault("valueRenderOption")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_589240 != nil:
    section.add "valueRenderOption", valid_589240
  var valid_589241 = query.getOrDefault("oauth_token")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "oauth_token", valid_589241
  var valid_589242 = query.getOrDefault("callback")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "callback", valid_589242
  var valid_589243 = query.getOrDefault("access_token")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "access_token", valid_589243
  var valid_589244 = query.getOrDefault("uploadType")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "uploadType", valid_589244
  var valid_589245 = query.getOrDefault("ranges")
  valid_589245 = validateParameter(valid_589245, JArray, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "ranges", valid_589245
  var valid_589246 = query.getOrDefault("key")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "key", valid_589246
  var valid_589247 = query.getOrDefault("$.xgafv")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = newJString("1"))
  if valid_589247 != nil:
    section.add "$.xgafv", valid_589247
  var valid_589248 = query.getOrDefault("dateTimeRenderOption")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_589248 != nil:
    section.add "dateTimeRenderOption", valid_589248
  var valid_589249 = query.getOrDefault("prettyPrint")
  valid_589249 = validateParameter(valid_589249, JBool, required = false,
                                 default = newJBool(true))
  if valid_589249 != nil:
    section.add "prettyPrint", valid_589249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589250: Call_SheetsSpreadsheetsValuesBatchGet_589231;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ## 
  let valid = call_589250.validator(path, query, header, formData, body)
  let scheme = call_589250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589250.url(scheme.get, call_589250.host, call_589250.base,
                         call_589250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589250, url, valid)

proc call*(call_589251: Call_SheetsSpreadsheetsValuesBatchGet_589231;
          spreadsheetId: string; majorDimension: string = "DIMENSION_UNSPECIFIED";
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; valueRenderOption: string = "FORMATTED_VALUE";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; ranges: JsonNode = nil; key: string = "";
          Xgafv: string = "1"; dateTimeRenderOption: string = "SERIAL_NUMBER";
          prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsValuesBatchGet
  ## Returns one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ##   majorDimension: string
  ##                 : The major dimension that results should use.
  ## 
  ## For example, if the spreadsheet data is: `A1=1,B1=2,A2=3,B2=4`,
  ## then requesting `range=A1:B2,majorDimension=ROWS` will return
  ## `[[1,2],[3,4]]`,
  ## whereas requesting `range=A1:B2,majorDimension=COLUMNS` will return
  ## `[[1,3],[2,4]]`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   valueRenderOption: string
  ##                    : How values should be represented in the output.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   ranges: JArray
  ##         : The A1 notation of the values to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   dateTimeRenderOption: string
  ##                       : How dates, times, and durations should be represented in the output.
  ## This is ignored if value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve data from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589252 = newJObject()
  var query_589253 = newJObject()
  add(query_589253, "majorDimension", newJString(majorDimension))
  add(query_589253, "upload_protocol", newJString(uploadProtocol))
  add(query_589253, "fields", newJString(fields))
  add(query_589253, "quotaUser", newJString(quotaUser))
  add(query_589253, "alt", newJString(alt))
  add(query_589253, "valueRenderOption", newJString(valueRenderOption))
  add(query_589253, "oauth_token", newJString(oauthToken))
  add(query_589253, "callback", newJString(callback))
  add(query_589253, "access_token", newJString(accessToken))
  add(query_589253, "uploadType", newJString(uploadType))
  if ranges != nil:
    query_589253.add "ranges", ranges
  add(query_589253, "key", newJString(key))
  add(query_589253, "$.xgafv", newJString(Xgafv))
  add(query_589253, "dateTimeRenderOption", newJString(dateTimeRenderOption))
  add(path_589252, "spreadsheetId", newJString(spreadsheetId))
  add(query_589253, "prettyPrint", newJBool(prettyPrint))
  result = call_589251.call(path_589252, query_589253, nil, nil, nil)

var sheetsSpreadsheetsValuesBatchGet* = Call_SheetsSpreadsheetsValuesBatchGet_589231(
    name: "sheetsSpreadsheetsValuesBatchGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchGet",
    validator: validate_SheetsSpreadsheetsValuesBatchGet_589232, base: "/",
    url: url_SheetsSpreadsheetsValuesBatchGet_589233, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_589254 = ref object of OpenApiRestCall_588450
proc url_SheetsSpreadsheetsValuesBatchGetByDataFilter_589256(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesBatchGetByDataFilter_589255(path: JsonNode;
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
  var valid_589257 = path.getOrDefault("spreadsheetId")
  valid_589257 = validateParameter(valid_589257, JString, required = true,
                                 default = nil)
  if valid_589257 != nil:
    section.add "spreadsheetId", valid_589257
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589258 = query.getOrDefault("upload_protocol")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "upload_protocol", valid_589258
  var valid_589259 = query.getOrDefault("fields")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "fields", valid_589259
  var valid_589260 = query.getOrDefault("quotaUser")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "quotaUser", valid_589260
  var valid_589261 = query.getOrDefault("alt")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = newJString("json"))
  if valid_589261 != nil:
    section.add "alt", valid_589261
  var valid_589262 = query.getOrDefault("oauth_token")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "oauth_token", valid_589262
  var valid_589263 = query.getOrDefault("callback")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "callback", valid_589263
  var valid_589264 = query.getOrDefault("access_token")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "access_token", valid_589264
  var valid_589265 = query.getOrDefault("uploadType")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "uploadType", valid_589265
  var valid_589266 = query.getOrDefault("key")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "key", valid_589266
  var valid_589267 = query.getOrDefault("$.xgafv")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = newJString("1"))
  if valid_589267 != nil:
    section.add "$.xgafv", valid_589267
  var valid_589268 = query.getOrDefault("prettyPrint")
  valid_589268 = validateParameter(valid_589268, JBool, required = false,
                                 default = newJBool(true))
  if valid_589268 != nil:
    section.add "prettyPrint", valid_589268
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

proc call*(call_589270: Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_589254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns one or more ranges of values that match the specified data filters.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters.  Ranges that match any of the data filters in
  ## the request will be returned.
  ## 
  let valid = call_589270.validator(path, query, header, formData, body)
  let scheme = call_589270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589270.url(scheme.get, call_589270.host, call_589270.base,
                         call_589270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589270, url, valid)

proc call*(call_589271: Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_589254;
          spreadsheetId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsValuesBatchGetByDataFilter
  ## Returns one or more ranges of values that match the specified data filters.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters.  Ranges that match any of the data filters in
  ## the request will be returned.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve data from.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589272 = newJObject()
  var query_589273 = newJObject()
  var body_589274 = newJObject()
  add(query_589273, "upload_protocol", newJString(uploadProtocol))
  add(query_589273, "fields", newJString(fields))
  add(query_589273, "quotaUser", newJString(quotaUser))
  add(query_589273, "alt", newJString(alt))
  add(query_589273, "oauth_token", newJString(oauthToken))
  add(query_589273, "callback", newJString(callback))
  add(query_589273, "access_token", newJString(accessToken))
  add(query_589273, "uploadType", newJString(uploadType))
  add(query_589273, "key", newJString(key))
  add(query_589273, "$.xgafv", newJString(Xgafv))
  add(path_589272, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_589274 = body
  add(query_589273, "prettyPrint", newJBool(prettyPrint))
  result = call_589271.call(path_589272, query_589273, nil, nil, body_589274)

var sheetsSpreadsheetsValuesBatchGetByDataFilter* = Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_589254(
    name: "sheetsSpreadsheetsValuesBatchGetByDataFilter",
    meth: HttpMethod.HttpPost, host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchGetByDataFilter",
    validator: validate_SheetsSpreadsheetsValuesBatchGetByDataFilter_589255,
    base: "/", url: url_SheetsSpreadsheetsValuesBatchGetByDataFilter_589256,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchUpdate_589275 = ref object of OpenApiRestCall_588450
proc url_SheetsSpreadsheetsValuesBatchUpdate_589277(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesBatchUpdate_589276(path: JsonNode;
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
  var valid_589278 = path.getOrDefault("spreadsheetId")
  valid_589278 = validateParameter(valid_589278, JString, required = true,
                                 default = nil)
  if valid_589278 != nil:
    section.add "spreadsheetId", valid_589278
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589279 = query.getOrDefault("upload_protocol")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "upload_protocol", valid_589279
  var valid_589280 = query.getOrDefault("fields")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "fields", valid_589280
  var valid_589281 = query.getOrDefault("quotaUser")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "quotaUser", valid_589281
  var valid_589282 = query.getOrDefault("alt")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = newJString("json"))
  if valid_589282 != nil:
    section.add "alt", valid_589282
  var valid_589283 = query.getOrDefault("oauth_token")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "oauth_token", valid_589283
  var valid_589284 = query.getOrDefault("callback")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "callback", valid_589284
  var valid_589285 = query.getOrDefault("access_token")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "access_token", valid_589285
  var valid_589286 = query.getOrDefault("uploadType")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "uploadType", valid_589286
  var valid_589287 = query.getOrDefault("key")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "key", valid_589287
  var valid_589288 = query.getOrDefault("$.xgafv")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = newJString("1"))
  if valid_589288 != nil:
    section.add "$.xgafv", valid_589288
  var valid_589289 = query.getOrDefault("prettyPrint")
  valid_589289 = validateParameter(valid_589289, JBool, required = false,
                                 default = newJBool(true))
  if valid_589289 != nil:
    section.add "prettyPrint", valid_589289
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

proc call*(call_589291: Call_SheetsSpreadsheetsValuesBatchUpdate_589275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## ValueRanges.
  ## 
  let valid = call_589291.validator(path, query, header, formData, body)
  let scheme = call_589291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589291.url(scheme.get, call_589291.host, call_589291.base,
                         call_589291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589291, url, valid)

proc call*(call_589292: Call_SheetsSpreadsheetsValuesBatchUpdate_589275;
          spreadsheetId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsValuesBatchUpdate
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## ValueRanges.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589293 = newJObject()
  var query_589294 = newJObject()
  var body_589295 = newJObject()
  add(query_589294, "upload_protocol", newJString(uploadProtocol))
  add(query_589294, "fields", newJString(fields))
  add(query_589294, "quotaUser", newJString(quotaUser))
  add(query_589294, "alt", newJString(alt))
  add(query_589294, "oauth_token", newJString(oauthToken))
  add(query_589294, "callback", newJString(callback))
  add(query_589294, "access_token", newJString(accessToken))
  add(query_589294, "uploadType", newJString(uploadType))
  add(query_589294, "key", newJString(key))
  add(query_589294, "$.xgafv", newJString(Xgafv))
  add(path_589293, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_589295 = body
  add(query_589294, "prettyPrint", newJBool(prettyPrint))
  result = call_589292.call(path_589293, query_589294, nil, nil, body_589295)

var sheetsSpreadsheetsValuesBatchUpdate* = Call_SheetsSpreadsheetsValuesBatchUpdate_589275(
    name: "sheetsSpreadsheetsValuesBatchUpdate", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchUpdate",
    validator: validate_SheetsSpreadsheetsValuesBatchUpdate_589276, base: "/",
    url: url_SheetsSpreadsheetsValuesBatchUpdate_589277, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_589296 = ref object of OpenApiRestCall_588450
proc url_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_589298(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_589297(
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
  var valid_589299 = path.getOrDefault("spreadsheetId")
  valid_589299 = validateParameter(valid_589299, JString, required = true,
                                 default = nil)
  if valid_589299 != nil:
    section.add "spreadsheetId", valid_589299
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589300 = query.getOrDefault("upload_protocol")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "upload_protocol", valid_589300
  var valid_589301 = query.getOrDefault("fields")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "fields", valid_589301
  var valid_589302 = query.getOrDefault("quotaUser")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "quotaUser", valid_589302
  var valid_589303 = query.getOrDefault("alt")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = newJString("json"))
  if valid_589303 != nil:
    section.add "alt", valid_589303
  var valid_589304 = query.getOrDefault("oauth_token")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "oauth_token", valid_589304
  var valid_589305 = query.getOrDefault("callback")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "callback", valid_589305
  var valid_589306 = query.getOrDefault("access_token")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "access_token", valid_589306
  var valid_589307 = query.getOrDefault("uploadType")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "uploadType", valid_589307
  var valid_589308 = query.getOrDefault("key")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "key", valid_589308
  var valid_589309 = query.getOrDefault("$.xgafv")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = newJString("1"))
  if valid_589309 != nil:
    section.add "$.xgafv", valid_589309
  var valid_589310 = query.getOrDefault("prettyPrint")
  valid_589310 = validateParameter(valid_589310, JBool, required = false,
                                 default = newJBool(true))
  if valid_589310 != nil:
    section.add "prettyPrint", valid_589310
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

proc call*(call_589312: Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_589296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## DataFilterValueRanges.
  ## 
  let valid = call_589312.validator(path, query, header, formData, body)
  let scheme = call_589312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589312.url(scheme.get, call_589312.host, call_589312.base,
                         call_589312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589312, url, valid)

proc call*(call_589313: Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_589296;
          spreadsheetId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsValuesBatchUpdateByDataFilter
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## DataFilterValueRanges.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589314 = newJObject()
  var query_589315 = newJObject()
  var body_589316 = newJObject()
  add(query_589315, "upload_protocol", newJString(uploadProtocol))
  add(query_589315, "fields", newJString(fields))
  add(query_589315, "quotaUser", newJString(quotaUser))
  add(query_589315, "alt", newJString(alt))
  add(query_589315, "oauth_token", newJString(oauthToken))
  add(query_589315, "callback", newJString(callback))
  add(query_589315, "access_token", newJString(accessToken))
  add(query_589315, "uploadType", newJString(uploadType))
  add(query_589315, "key", newJString(key))
  add(query_589315, "$.xgafv", newJString(Xgafv))
  add(path_589314, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_589316 = body
  add(query_589315, "prettyPrint", newJBool(prettyPrint))
  result = call_589313.call(path_589314, query_589315, nil, nil, body_589316)

var sheetsSpreadsheetsValuesBatchUpdateByDataFilter* = Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_589296(
    name: "sheetsSpreadsheetsValuesBatchUpdateByDataFilter",
    meth: HttpMethod.HttpPost, host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchUpdateByDataFilter",
    validator: validate_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_589297,
    base: "/", url: url_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_589298,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsBatchUpdate_589317 = ref object of OpenApiRestCall_588450
proc url_SheetsSpreadsheetsBatchUpdate_589319(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsBatchUpdate_589318(path: JsonNode; query: JsonNode;
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
  var valid_589320 = path.getOrDefault("spreadsheetId")
  valid_589320 = validateParameter(valid_589320, JString, required = true,
                                 default = nil)
  if valid_589320 != nil:
    section.add "spreadsheetId", valid_589320
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589321 = query.getOrDefault("upload_protocol")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "upload_protocol", valid_589321
  var valid_589322 = query.getOrDefault("fields")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "fields", valid_589322
  var valid_589323 = query.getOrDefault("quotaUser")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "quotaUser", valid_589323
  var valid_589324 = query.getOrDefault("alt")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = newJString("json"))
  if valid_589324 != nil:
    section.add "alt", valid_589324
  var valid_589325 = query.getOrDefault("oauth_token")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = nil)
  if valid_589325 != nil:
    section.add "oauth_token", valid_589325
  var valid_589326 = query.getOrDefault("callback")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "callback", valid_589326
  var valid_589327 = query.getOrDefault("access_token")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "access_token", valid_589327
  var valid_589328 = query.getOrDefault("uploadType")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "uploadType", valid_589328
  var valid_589329 = query.getOrDefault("key")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = nil)
  if valid_589329 != nil:
    section.add "key", valid_589329
  var valid_589330 = query.getOrDefault("$.xgafv")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = newJString("1"))
  if valid_589330 != nil:
    section.add "$.xgafv", valid_589330
  var valid_589331 = query.getOrDefault("prettyPrint")
  valid_589331 = validateParameter(valid_589331, JBool, required = false,
                                 default = newJBool(true))
  if valid_589331 != nil:
    section.add "prettyPrint", valid_589331
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

proc call*(call_589333: Call_SheetsSpreadsheetsBatchUpdate_589317; path: JsonNode;
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
  let valid = call_589333.validator(path, query, header, formData, body)
  let scheme = call_589333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589333.url(scheme.get, call_589333.host, call_589333.base,
                         call_589333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589333, url, valid)

proc call*(call_589334: Call_SheetsSpreadsheetsBatchUpdate_589317;
          spreadsheetId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The spreadsheet to apply the updates to.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589335 = newJObject()
  var query_589336 = newJObject()
  var body_589337 = newJObject()
  add(query_589336, "upload_protocol", newJString(uploadProtocol))
  add(query_589336, "fields", newJString(fields))
  add(query_589336, "quotaUser", newJString(quotaUser))
  add(query_589336, "alt", newJString(alt))
  add(query_589336, "oauth_token", newJString(oauthToken))
  add(query_589336, "callback", newJString(callback))
  add(query_589336, "access_token", newJString(accessToken))
  add(query_589336, "uploadType", newJString(uploadType))
  add(query_589336, "key", newJString(key))
  add(query_589336, "$.xgafv", newJString(Xgafv))
  add(path_589335, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_589337 = body
  add(query_589336, "prettyPrint", newJBool(prettyPrint))
  result = call_589334.call(path_589335, query_589336, nil, nil, body_589337)

var sheetsSpreadsheetsBatchUpdate* = Call_SheetsSpreadsheetsBatchUpdate_589317(
    name: "sheetsSpreadsheetsBatchUpdate", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}:batchUpdate",
    validator: validate_SheetsSpreadsheetsBatchUpdate_589318, base: "/",
    url: url_SheetsSpreadsheetsBatchUpdate_589319, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsGetByDataFilter_589338 = ref object of OpenApiRestCall_588450
proc url_SheetsSpreadsheetsGetByDataFilter_589340(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsGetByDataFilter_589339(path: JsonNode;
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
  var valid_589341 = path.getOrDefault("spreadsheetId")
  valid_589341 = validateParameter(valid_589341, JString, required = true,
                                 default = nil)
  if valid_589341 != nil:
    section.add "spreadsheetId", valid_589341
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589342 = query.getOrDefault("upload_protocol")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "upload_protocol", valid_589342
  var valid_589343 = query.getOrDefault("fields")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = nil)
  if valid_589343 != nil:
    section.add "fields", valid_589343
  var valid_589344 = query.getOrDefault("quotaUser")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "quotaUser", valid_589344
  var valid_589345 = query.getOrDefault("alt")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = newJString("json"))
  if valid_589345 != nil:
    section.add "alt", valid_589345
  var valid_589346 = query.getOrDefault("oauth_token")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "oauth_token", valid_589346
  var valid_589347 = query.getOrDefault("callback")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "callback", valid_589347
  var valid_589348 = query.getOrDefault("access_token")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "access_token", valid_589348
  var valid_589349 = query.getOrDefault("uploadType")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "uploadType", valid_589349
  var valid_589350 = query.getOrDefault("key")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = nil)
  if valid_589350 != nil:
    section.add "key", valid_589350
  var valid_589351 = query.getOrDefault("$.xgafv")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = newJString("1"))
  if valid_589351 != nil:
    section.add "$.xgafv", valid_589351
  var valid_589352 = query.getOrDefault("prettyPrint")
  valid_589352 = validateParameter(valid_589352, JBool, required = false,
                                 default = newJBool(true))
  if valid_589352 != nil:
    section.add "prettyPrint", valid_589352
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

proc call*(call_589354: Call_SheetsSpreadsheetsGetByDataFilter_589338;
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
  let valid = call_589354.validator(path, query, header, formData, body)
  let scheme = call_589354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589354.url(scheme.get, call_589354.host, call_589354.base,
                         call_589354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589354, url, valid)

proc call*(call_589355: Call_SheetsSpreadsheetsGetByDataFilter_589338;
          spreadsheetId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The spreadsheet to request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589356 = newJObject()
  var query_589357 = newJObject()
  var body_589358 = newJObject()
  add(query_589357, "upload_protocol", newJString(uploadProtocol))
  add(query_589357, "fields", newJString(fields))
  add(query_589357, "quotaUser", newJString(quotaUser))
  add(query_589357, "alt", newJString(alt))
  add(query_589357, "oauth_token", newJString(oauthToken))
  add(query_589357, "callback", newJString(callback))
  add(query_589357, "access_token", newJString(accessToken))
  add(query_589357, "uploadType", newJString(uploadType))
  add(query_589357, "key", newJString(key))
  add(query_589357, "$.xgafv", newJString(Xgafv))
  add(path_589356, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_589358 = body
  add(query_589357, "prettyPrint", newJBool(prettyPrint))
  result = call_589355.call(path_589356, query_589357, nil, nil, body_589358)

var sheetsSpreadsheetsGetByDataFilter* = Call_SheetsSpreadsheetsGetByDataFilter_589338(
    name: "sheetsSpreadsheetsGetByDataFilter", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}:getByDataFilter",
    validator: validate_SheetsSpreadsheetsGetByDataFilter_589339, base: "/",
    url: url_SheetsSpreadsheetsGetByDataFilter_589340, schemes: {Scheme.Https})
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
