
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Data Loss Prevention (DLP)
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Provides methods for detection, risk analysis, and de-identification of privacy-sensitive fragments in text, images, and Google Cloud Platform storage repositories.
## 
## https://cloud.google.com/dlp/docs/
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
  gcpServiceName = "dlp"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DlpInfoTypesList_579644 = ref object of OpenApiRestCall_579373
proc url_DlpInfoTypesList_579646(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DlpInfoTypesList_579645(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
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
  ##   filter: JString
  ##         : Optional filter to only return infoTypes supported by certain parts of the
  ## API. Defaults to supported_by=INSPECT.
  ##   location: JString
  ##           : The geographic location to list info types. Reserved for future
  ## extensions.
  ##   callback: JString
  ##           : JSONP
  ##   languageCode: JString
  ##               : Optional BCP-47 language code for localized infoType friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
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
  var valid_579778 = query.getOrDefault("filter")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "filter", valid_579778
  var valid_579779 = query.getOrDefault("location")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "location", valid_579779
  var valid_579780 = query.getOrDefault("callback")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = nil)
  if valid_579780 != nil:
    section.add "callback", valid_579780
  var valid_579781 = query.getOrDefault("languageCode")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = nil)
  if valid_579781 != nil:
    section.add "languageCode", valid_579781
  var valid_579782 = query.getOrDefault("fields")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "fields", valid_579782
  var valid_579783 = query.getOrDefault("access_token")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "access_token", valid_579783
  var valid_579784 = query.getOrDefault("upload_protocol")
  valid_579784 = validateParameter(valid_579784, JString, required = false,
                                 default = nil)
  if valid_579784 != nil:
    section.add "upload_protocol", valid_579784
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579807: Call_DlpInfoTypesList_579644; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
  ## 
  let valid = call_579807.validator(path, query, header, formData, body)
  let scheme = call_579807.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579807.url(scheme.get, call_579807.host, call_579807.base,
                         call_579807.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579807, url, valid)

proc call*(call_579878: Call_DlpInfoTypesList_579644; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; location: string = ""; callback: string = "";
          languageCode: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpInfoTypesList
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
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
  ##   filter: string
  ##         : Optional filter to only return infoTypes supported by certain parts of the
  ## API. Defaults to supported_by=INSPECT.
  ##   location: string
  ##           : The geographic location to list info types. Reserved for future
  ## extensions.
  ##   callback: string
  ##           : JSONP
  ##   languageCode: string
  ##               : Optional BCP-47 language code for localized infoType friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579879 = newJObject()
  add(query_579879, "key", newJString(key))
  add(query_579879, "prettyPrint", newJBool(prettyPrint))
  add(query_579879, "oauth_token", newJString(oauthToken))
  add(query_579879, "$.xgafv", newJString(Xgafv))
  add(query_579879, "alt", newJString(alt))
  add(query_579879, "uploadType", newJString(uploadType))
  add(query_579879, "quotaUser", newJString(quotaUser))
  add(query_579879, "filter", newJString(filter))
  add(query_579879, "location", newJString(location))
  add(query_579879, "callback", newJString(callback))
  add(query_579879, "languageCode", newJString(languageCode))
  add(query_579879, "fields", newJString(fields))
  add(query_579879, "access_token", newJString(accessToken))
  add(query_579879, "upload_protocol", newJString(uploadProtocol))
  result = call_579878.call(nil, query_579879, nil, nil, nil)

var dlpInfoTypesList* = Call_DlpInfoTypesList_579644(name: "dlpInfoTypesList",
    meth: HttpMethod.HttpGet, host: "dlp.googleapis.com", route: "/v2/infoTypes",
    validator: validate_DlpInfoTypesList_579645, base: "/",
    url: url_DlpInfoTypesList_579646, schemes: {Scheme.Https})
type
  Call_DlpLocationsInfoTypesList_579919 = ref object of OpenApiRestCall_579373
proc url_DlpLocationsInfoTypesList_579921(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/infoTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpLocationsInfoTypesList_579920(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   location: JString (required)
  ##           : The geographic location to list info types. Reserved for future
  ## extensions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `location` field"
  var valid_579936 = path.getOrDefault("location")
  valid_579936 = validateParameter(valid_579936, JString, required = true,
                                 default = nil)
  if valid_579936 != nil:
    section.add "location", valid_579936
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
  ##   filter: JString
  ##         : Optional filter to only return infoTypes supported by certain parts of the
  ## API. Defaults to supported_by=INSPECT.
  ##   callback: JString
  ##           : JSONP
  ##   languageCode: JString
  ##               : Optional BCP-47 language code for localized infoType friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579937 = query.getOrDefault("key")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "key", valid_579937
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
  var valid_579940 = query.getOrDefault("$.xgafv")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = newJString("1"))
  if valid_579940 != nil:
    section.add "$.xgafv", valid_579940
  var valid_579941 = query.getOrDefault("alt")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = newJString("json"))
  if valid_579941 != nil:
    section.add "alt", valid_579941
  var valid_579942 = query.getOrDefault("uploadType")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = nil)
  if valid_579942 != nil:
    section.add "uploadType", valid_579942
  var valid_579943 = query.getOrDefault("quotaUser")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "quotaUser", valid_579943
  var valid_579944 = query.getOrDefault("filter")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "filter", valid_579944
  var valid_579945 = query.getOrDefault("callback")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "callback", valid_579945
  var valid_579946 = query.getOrDefault("languageCode")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "languageCode", valid_579946
  var valid_579947 = query.getOrDefault("fields")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "fields", valid_579947
  var valid_579948 = query.getOrDefault("access_token")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "access_token", valid_579948
  var valid_579949 = query.getOrDefault("upload_protocol")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "upload_protocol", valid_579949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579950: Call_DlpLocationsInfoTypesList_579919; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
  ## 
  let valid = call_579950.validator(path, query, header, formData, body)
  let scheme = call_579950.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579950.url(scheme.get, call_579950.host, call_579950.base,
                         call_579950.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579950, url, valid)

proc call*(call_579951: Call_DlpLocationsInfoTypesList_579919; location: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; filter: string = ""; callback: string = "";
          languageCode: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpLocationsInfoTypesList
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
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
  ##   filter: string
  ##         : Optional filter to only return infoTypes supported by certain parts of the
  ## API. Defaults to supported_by=INSPECT.
  ##   location: string (required)
  ##           : The geographic location to list info types. Reserved for future
  ## extensions.
  ##   callback: string
  ##           : JSONP
  ##   languageCode: string
  ##               : Optional BCP-47 language code for localized infoType friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579952 = newJObject()
  var query_579953 = newJObject()
  add(query_579953, "key", newJString(key))
  add(query_579953, "prettyPrint", newJBool(prettyPrint))
  add(query_579953, "oauth_token", newJString(oauthToken))
  add(query_579953, "$.xgafv", newJString(Xgafv))
  add(query_579953, "alt", newJString(alt))
  add(query_579953, "uploadType", newJString(uploadType))
  add(query_579953, "quotaUser", newJString(quotaUser))
  add(query_579953, "filter", newJString(filter))
  add(path_579952, "location", newJString(location))
  add(query_579953, "callback", newJString(callback))
  add(query_579953, "languageCode", newJString(languageCode))
  add(query_579953, "fields", newJString(fields))
  add(query_579953, "access_token", newJString(accessToken))
  add(query_579953, "upload_protocol", newJString(uploadProtocol))
  result = call_579951.call(path_579952, query_579953, nil, nil, nil)

var dlpLocationsInfoTypesList* = Call_DlpLocationsInfoTypesList_579919(
    name: "dlpLocationsInfoTypesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/locations/{location}/infoTypes",
    validator: validate_DlpLocationsInfoTypesList_579920, base: "/",
    url: url_DlpLocationsInfoTypesList_579921, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsInspectTemplatesGet_579954 = ref object of OpenApiRestCall_579373
proc url_DlpOrganizationsInspectTemplatesGet_579956(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpOrganizationsInspectTemplatesGet_579955(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Resource name of the organization and inspectTemplate to be read, for
  ## example `organizations/433245324/inspectTemplates/432452342` or
  ## projects/project-id/inspectTemplates/432452342.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579957 = path.getOrDefault("name")
  valid_579957 = validateParameter(valid_579957, JString, required = true,
                                 default = nil)
  if valid_579957 != nil:
    section.add "name", valid_579957
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

proc call*(call_579969: Call_DlpOrganizationsInspectTemplatesGet_579954;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  let valid = call_579969.validator(path, query, header, formData, body)
  let scheme = call_579969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579969.url(scheme.get, call_579969.host, call_579969.base,
                         call_579969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579969, url, valid)

proc call*(call_579970: Call_DlpOrganizationsInspectTemplatesGet_579954;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpOrganizationsInspectTemplatesGet
  ## Gets an InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
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
  ##   name: string (required)
  ##       : Required. Resource name of the organization and inspectTemplate to be read, for
  ## example `organizations/433245324/inspectTemplates/432452342` or
  ## projects/project-id/inspectTemplates/432452342.
  ##   callback: string
  ##           : JSONP
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
  add(query_579972, "alt", newJString(alt))
  add(query_579972, "uploadType", newJString(uploadType))
  add(query_579972, "quotaUser", newJString(quotaUser))
  add(path_579971, "name", newJString(name))
  add(query_579972, "callback", newJString(callback))
  add(query_579972, "fields", newJString(fields))
  add(query_579972, "access_token", newJString(accessToken))
  add(query_579972, "upload_protocol", newJString(uploadProtocol))
  result = call_579970.call(path_579971, query_579972, nil, nil, nil)

var dlpOrganizationsInspectTemplatesGet* = Call_DlpOrganizationsInspectTemplatesGet_579954(
    name: "dlpOrganizationsInspectTemplatesGet", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{name}",
    validator: validate_DlpOrganizationsInspectTemplatesGet_579955, base: "/",
    url: url_DlpOrganizationsInspectTemplatesGet_579956, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsInspectTemplatesPatch_579992 = ref object of OpenApiRestCall_579373
proc url_DlpOrganizationsInspectTemplatesPatch_579994(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpOrganizationsInspectTemplatesPatch_579993(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Resource name of organization and inspectTemplate to be updated, for
  ## example `organizations/433245324/inspectTemplates/432452342` or
  ## projects/project-id/inspectTemplates/432452342.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579995 = path.getOrDefault("name")
  valid_579995 = validateParameter(valid_579995, JString, required = true,
                                 default = nil)
  if valid_579995 != nil:
    section.add "name", valid_579995
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
  var valid_579996 = query.getOrDefault("key")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "key", valid_579996
  var valid_579997 = query.getOrDefault("prettyPrint")
  valid_579997 = validateParameter(valid_579997, JBool, required = false,
                                 default = newJBool(true))
  if valid_579997 != nil:
    section.add "prettyPrint", valid_579997
  var valid_579998 = query.getOrDefault("oauth_token")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "oauth_token", valid_579998
  var valid_579999 = query.getOrDefault("$.xgafv")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = newJString("1"))
  if valid_579999 != nil:
    section.add "$.xgafv", valid_579999
  var valid_580000 = query.getOrDefault("alt")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = newJString("json"))
  if valid_580000 != nil:
    section.add "alt", valid_580000
  var valid_580001 = query.getOrDefault("uploadType")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "uploadType", valid_580001
  var valid_580002 = query.getOrDefault("quotaUser")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "quotaUser", valid_580002
  var valid_580003 = query.getOrDefault("callback")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "callback", valid_580003
  var valid_580004 = query.getOrDefault("fields")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "fields", valid_580004
  var valid_580005 = query.getOrDefault("access_token")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "access_token", valid_580005
  var valid_580006 = query.getOrDefault("upload_protocol")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "upload_protocol", valid_580006
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

proc call*(call_580008: Call_DlpOrganizationsInspectTemplatesPatch_579992;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  let valid = call_580008.validator(path, query, header, formData, body)
  let scheme = call_580008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580008.url(scheme.get, call_580008.host, call_580008.base,
                         call_580008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580008, url, valid)

proc call*(call_580009: Call_DlpOrganizationsInspectTemplatesPatch_579992;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpOrganizationsInspectTemplatesPatch
  ## Updates the InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
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
  ##   name: string (required)
  ##       : Required. Resource name of organization and inspectTemplate to be updated, for
  ## example `organizations/433245324/inspectTemplates/432452342` or
  ## projects/project-id/inspectTemplates/432452342.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580010 = newJObject()
  var query_580011 = newJObject()
  var body_580012 = newJObject()
  add(query_580011, "key", newJString(key))
  add(query_580011, "prettyPrint", newJBool(prettyPrint))
  add(query_580011, "oauth_token", newJString(oauthToken))
  add(query_580011, "$.xgafv", newJString(Xgafv))
  add(query_580011, "alt", newJString(alt))
  add(query_580011, "uploadType", newJString(uploadType))
  add(query_580011, "quotaUser", newJString(quotaUser))
  add(path_580010, "name", newJString(name))
  if body != nil:
    body_580012 = body
  add(query_580011, "callback", newJString(callback))
  add(query_580011, "fields", newJString(fields))
  add(query_580011, "access_token", newJString(accessToken))
  add(query_580011, "upload_protocol", newJString(uploadProtocol))
  result = call_580009.call(path_580010, query_580011, nil, nil, body_580012)

var dlpOrganizationsInspectTemplatesPatch* = Call_DlpOrganizationsInspectTemplatesPatch_579992(
    name: "dlpOrganizationsInspectTemplatesPatch", meth: HttpMethod.HttpPatch,
    host: "dlp.googleapis.com", route: "/v2/{name}",
    validator: validate_DlpOrganizationsInspectTemplatesPatch_579993, base: "/",
    url: url_DlpOrganizationsInspectTemplatesPatch_579994, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsInspectTemplatesDelete_579973 = ref object of OpenApiRestCall_579373
proc url_DlpOrganizationsInspectTemplatesDelete_579975(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpOrganizationsInspectTemplatesDelete_579974(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Resource name of the organization and inspectTemplate to be deleted, for
  ## example `organizations/433245324/inspectTemplates/432452342` or
  ## projects/project-id/inspectTemplates/432452342.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579976 = path.getOrDefault("name")
  valid_579976 = validateParameter(valid_579976, JString, required = true,
                                 default = nil)
  if valid_579976 != nil:
    section.add "name", valid_579976
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
  if body != nil:
    result.add "body", body

proc call*(call_579988: Call_DlpOrganizationsInspectTemplatesDelete_579973;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  let valid = call_579988.validator(path, query, header, formData, body)
  let scheme = call_579988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579988.url(scheme.get, call_579988.host, call_579988.base,
                         call_579988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579988, url, valid)

proc call*(call_579989: Call_DlpOrganizationsInspectTemplatesDelete_579973;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpOrganizationsInspectTemplatesDelete
  ## Deletes an InspectTemplate.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
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
  ##   name: string (required)
  ##       : Required. Resource name of the organization and inspectTemplate to be deleted, for
  ## example `organizations/433245324/inspectTemplates/432452342` or
  ## projects/project-id/inspectTemplates/432452342.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579990 = newJObject()
  var query_579991 = newJObject()
  add(query_579991, "key", newJString(key))
  add(query_579991, "prettyPrint", newJBool(prettyPrint))
  add(query_579991, "oauth_token", newJString(oauthToken))
  add(query_579991, "$.xgafv", newJString(Xgafv))
  add(query_579991, "alt", newJString(alt))
  add(query_579991, "uploadType", newJString(uploadType))
  add(query_579991, "quotaUser", newJString(quotaUser))
  add(path_579990, "name", newJString(name))
  add(query_579991, "callback", newJString(callback))
  add(query_579991, "fields", newJString(fields))
  add(query_579991, "access_token", newJString(accessToken))
  add(query_579991, "upload_protocol", newJString(uploadProtocol))
  result = call_579989.call(path_579990, query_579991, nil, nil, nil)

var dlpOrganizationsInspectTemplatesDelete* = Call_DlpOrganizationsInspectTemplatesDelete_579973(
    name: "dlpOrganizationsInspectTemplatesDelete", meth: HttpMethod.HttpDelete,
    host: "dlp.googleapis.com", route: "/v2/{name}",
    validator: validate_DlpOrganizationsInspectTemplatesDelete_579974, base: "/",
    url: url_DlpOrganizationsInspectTemplatesDelete_579975,
    schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersActivate_580013 = ref object of OpenApiRestCall_579373
proc url_DlpProjectsJobTriggersActivate_580015(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":activate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersActivate_580014(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Activate a job trigger. Causes the immediate execute of a trigger
  ## instead of waiting on the trigger event to occur.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Resource name of the trigger to activate, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580016 = path.getOrDefault("name")
  valid_580016 = validateParameter(valid_580016, JString, required = true,
                                 default = nil)
  if valid_580016 != nil:
    section.add "name", valid_580016
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
  var valid_580017 = query.getOrDefault("key")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "key", valid_580017
  var valid_580018 = query.getOrDefault("prettyPrint")
  valid_580018 = validateParameter(valid_580018, JBool, required = false,
                                 default = newJBool(true))
  if valid_580018 != nil:
    section.add "prettyPrint", valid_580018
  var valid_580019 = query.getOrDefault("oauth_token")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "oauth_token", valid_580019
  var valid_580020 = query.getOrDefault("$.xgafv")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = newJString("1"))
  if valid_580020 != nil:
    section.add "$.xgafv", valid_580020
  var valid_580021 = query.getOrDefault("alt")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = newJString("json"))
  if valid_580021 != nil:
    section.add "alt", valid_580021
  var valid_580022 = query.getOrDefault("uploadType")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "uploadType", valid_580022
  var valid_580023 = query.getOrDefault("quotaUser")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "quotaUser", valid_580023
  var valid_580024 = query.getOrDefault("callback")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "callback", valid_580024
  var valid_580025 = query.getOrDefault("fields")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "fields", valid_580025
  var valid_580026 = query.getOrDefault("access_token")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "access_token", valid_580026
  var valid_580027 = query.getOrDefault("upload_protocol")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "upload_protocol", valid_580027
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

proc call*(call_580029: Call_DlpProjectsJobTriggersActivate_580013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activate a job trigger. Causes the immediate execute of a trigger
  ## instead of waiting on the trigger event to occur.
  ## 
  let valid = call_580029.validator(path, query, header, formData, body)
  let scheme = call_580029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580029.url(scheme.get, call_580029.host, call_580029.base,
                         call_580029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580029, url, valid)

proc call*(call_580030: Call_DlpProjectsJobTriggersActivate_580013; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsJobTriggersActivate
  ## Activate a job trigger. Causes the immediate execute of a trigger
  ## instead of waiting on the trigger event to occur.
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
  ##   name: string (required)
  ##       : Required. Resource name of the trigger to activate, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580031 = newJObject()
  var query_580032 = newJObject()
  var body_580033 = newJObject()
  add(query_580032, "key", newJString(key))
  add(query_580032, "prettyPrint", newJBool(prettyPrint))
  add(query_580032, "oauth_token", newJString(oauthToken))
  add(query_580032, "$.xgafv", newJString(Xgafv))
  add(query_580032, "alt", newJString(alt))
  add(query_580032, "uploadType", newJString(uploadType))
  add(query_580032, "quotaUser", newJString(quotaUser))
  add(path_580031, "name", newJString(name))
  if body != nil:
    body_580033 = body
  add(query_580032, "callback", newJString(callback))
  add(query_580032, "fields", newJString(fields))
  add(query_580032, "access_token", newJString(accessToken))
  add(query_580032, "upload_protocol", newJString(uploadProtocol))
  result = call_580030.call(path_580031, query_580032, nil, nil, body_580033)

var dlpProjectsJobTriggersActivate* = Call_DlpProjectsJobTriggersActivate_580013(
    name: "dlpProjectsJobTriggersActivate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{name}:activate",
    validator: validate_DlpProjectsJobTriggersActivate_580014, base: "/",
    url: url_DlpProjectsJobTriggersActivate_580015, schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsCancel_580034 = ref object of OpenApiRestCall_579373
proc url_DlpProjectsDlpJobsCancel_580036(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpProjectsDlpJobsCancel_580035(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running DlpJob. The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the DlpJob resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580037 = path.getOrDefault("name")
  valid_580037 = validateParameter(valid_580037, JString, required = true,
                                 default = nil)
  if valid_580037 != nil:
    section.add "name", valid_580037
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
  var valid_580038 = query.getOrDefault("key")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "key", valid_580038
  var valid_580039 = query.getOrDefault("prettyPrint")
  valid_580039 = validateParameter(valid_580039, JBool, required = false,
                                 default = newJBool(true))
  if valid_580039 != nil:
    section.add "prettyPrint", valid_580039
  var valid_580040 = query.getOrDefault("oauth_token")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "oauth_token", valid_580040
  var valid_580041 = query.getOrDefault("$.xgafv")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = newJString("1"))
  if valid_580041 != nil:
    section.add "$.xgafv", valid_580041
  var valid_580042 = query.getOrDefault("alt")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = newJString("json"))
  if valid_580042 != nil:
    section.add "alt", valid_580042
  var valid_580043 = query.getOrDefault("uploadType")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "uploadType", valid_580043
  var valid_580044 = query.getOrDefault("quotaUser")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "quotaUser", valid_580044
  var valid_580045 = query.getOrDefault("callback")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "callback", valid_580045
  var valid_580046 = query.getOrDefault("fields")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "fields", valid_580046
  var valid_580047 = query.getOrDefault("access_token")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "access_token", valid_580047
  var valid_580048 = query.getOrDefault("upload_protocol")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "upload_protocol", valid_580048
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

proc call*(call_580050: Call_DlpProjectsDlpJobsCancel_580034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running DlpJob. The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  let valid = call_580050.validator(path, query, header, formData, body)
  let scheme = call_580050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580050.url(scheme.get, call_580050.host, call_580050.base,
                         call_580050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580050, url, valid)

proc call*(call_580051: Call_DlpProjectsDlpJobsCancel_580034; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsDlpJobsCancel
  ## Starts asynchronous cancellation on a long-running DlpJob. The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
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
  ##   name: string (required)
  ##       : Required. The name of the DlpJob resource to be cancelled.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580052 = newJObject()
  var query_580053 = newJObject()
  var body_580054 = newJObject()
  add(query_580053, "key", newJString(key))
  add(query_580053, "prettyPrint", newJBool(prettyPrint))
  add(query_580053, "oauth_token", newJString(oauthToken))
  add(query_580053, "$.xgafv", newJString(Xgafv))
  add(query_580053, "alt", newJString(alt))
  add(query_580053, "uploadType", newJString(uploadType))
  add(query_580053, "quotaUser", newJString(quotaUser))
  add(path_580052, "name", newJString(name))
  if body != nil:
    body_580054 = body
  add(query_580053, "callback", newJString(callback))
  add(query_580053, "fields", newJString(fields))
  add(query_580053, "access_token", newJString(accessToken))
  add(query_580053, "upload_protocol", newJString(uploadProtocol))
  result = call_580051.call(path_580052, query_580053, nil, nil, body_580054)

var dlpProjectsDlpJobsCancel* = Call_DlpProjectsDlpJobsCancel_580034(
    name: "dlpProjectsDlpJobsCancel", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{name}:cancel",
    validator: validate_DlpProjectsDlpJobsCancel_580035, base: "/",
    url: url_DlpProjectsDlpJobsCancel_580036, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentDeidentify_580055 = ref object of OpenApiRestCall_579373
proc url_DlpProjectsContentDeidentify_580057(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/content:deidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpProjectsContentDeidentify_580056(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580058 = path.getOrDefault("parent")
  valid_580058 = validateParameter(valid_580058, JString, required = true,
                                 default = nil)
  if valid_580058 != nil:
    section.add "parent", valid_580058
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
  var valid_580059 = query.getOrDefault("key")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "key", valid_580059
  var valid_580060 = query.getOrDefault("prettyPrint")
  valid_580060 = validateParameter(valid_580060, JBool, required = false,
                                 default = newJBool(true))
  if valid_580060 != nil:
    section.add "prettyPrint", valid_580060
  var valid_580061 = query.getOrDefault("oauth_token")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "oauth_token", valid_580061
  var valid_580062 = query.getOrDefault("$.xgafv")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = newJString("1"))
  if valid_580062 != nil:
    section.add "$.xgafv", valid_580062
  var valid_580063 = query.getOrDefault("alt")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = newJString("json"))
  if valid_580063 != nil:
    section.add "alt", valid_580063
  var valid_580064 = query.getOrDefault("uploadType")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "uploadType", valid_580064
  var valid_580065 = query.getOrDefault("quotaUser")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "quotaUser", valid_580065
  var valid_580066 = query.getOrDefault("callback")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "callback", valid_580066
  var valid_580067 = query.getOrDefault("fields")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "fields", valid_580067
  var valid_580068 = query.getOrDefault("access_token")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "access_token", valid_580068
  var valid_580069 = query.getOrDefault("upload_protocol")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "upload_protocol", valid_580069
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

proc call*(call_580071: Call_DlpProjectsContentDeidentify_580055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  let valid = call_580071.validator(path, query, header, formData, body)
  let scheme = call_580071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580071.url(scheme.get, call_580071.host, call_580071.base,
                         call_580071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580071, url, valid)

proc call*(call_580072: Call_DlpProjectsContentDeidentify_580055; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsContentDeidentify
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
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
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580073 = newJObject()
  var query_580074 = newJObject()
  var body_580075 = newJObject()
  add(query_580074, "key", newJString(key))
  add(query_580074, "prettyPrint", newJBool(prettyPrint))
  add(query_580074, "oauth_token", newJString(oauthToken))
  add(query_580074, "$.xgafv", newJString(Xgafv))
  add(query_580074, "alt", newJString(alt))
  add(query_580074, "uploadType", newJString(uploadType))
  add(query_580074, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580075 = body
  add(query_580074, "callback", newJString(callback))
  add(path_580073, "parent", newJString(parent))
  add(query_580074, "fields", newJString(fields))
  add(query_580074, "access_token", newJString(accessToken))
  add(query_580074, "upload_protocol", newJString(uploadProtocol))
  result = call_580072.call(path_580073, query_580074, nil, nil, body_580075)

var dlpProjectsContentDeidentify* = Call_DlpProjectsContentDeidentify_580055(
    name: "dlpProjectsContentDeidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/content:deidentify",
    validator: validate_DlpProjectsContentDeidentify_580056, base: "/",
    url: url_DlpProjectsContentDeidentify_580057, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentInspect_580076 = ref object of OpenApiRestCall_579373
proc url_DlpProjectsContentInspect_580078(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/content:inspect")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpProjectsContentInspect_580077(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  ## For how to guides, see https://cloud.google.com/dlp/docs/inspecting-images
  ## and https://cloud.google.com/dlp/docs/inspecting-text,
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580079 = path.getOrDefault("parent")
  valid_580079 = validateParameter(valid_580079, JString, required = true,
                                 default = nil)
  if valid_580079 != nil:
    section.add "parent", valid_580079
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
  var valid_580080 = query.getOrDefault("key")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "key", valid_580080
  var valid_580081 = query.getOrDefault("prettyPrint")
  valid_580081 = validateParameter(valid_580081, JBool, required = false,
                                 default = newJBool(true))
  if valid_580081 != nil:
    section.add "prettyPrint", valid_580081
  var valid_580082 = query.getOrDefault("oauth_token")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "oauth_token", valid_580082
  var valid_580083 = query.getOrDefault("$.xgafv")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = newJString("1"))
  if valid_580083 != nil:
    section.add "$.xgafv", valid_580083
  var valid_580084 = query.getOrDefault("alt")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = newJString("json"))
  if valid_580084 != nil:
    section.add "alt", valid_580084
  var valid_580085 = query.getOrDefault("uploadType")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "uploadType", valid_580085
  var valid_580086 = query.getOrDefault("quotaUser")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "quotaUser", valid_580086
  var valid_580087 = query.getOrDefault("callback")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "callback", valid_580087
  var valid_580088 = query.getOrDefault("fields")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "fields", valid_580088
  var valid_580089 = query.getOrDefault("access_token")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "access_token", valid_580089
  var valid_580090 = query.getOrDefault("upload_protocol")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "upload_protocol", valid_580090
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

proc call*(call_580092: Call_DlpProjectsContentInspect_580076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  ## For how to guides, see https://cloud.google.com/dlp/docs/inspecting-images
  ## and https://cloud.google.com/dlp/docs/inspecting-text,
  ## 
  let valid = call_580092.validator(path, query, header, formData, body)
  let scheme = call_580092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580092.url(scheme.get, call_580092.host, call_580092.base,
                         call_580092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580092, url, valid)

proc call*(call_580093: Call_DlpProjectsContentInspect_580076; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsContentInspect
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  ## For how to guides, see https://cloud.google.com/dlp/docs/inspecting-images
  ## and https://cloud.google.com/dlp/docs/inspecting-text,
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
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580094 = newJObject()
  var query_580095 = newJObject()
  var body_580096 = newJObject()
  add(query_580095, "key", newJString(key))
  add(query_580095, "prettyPrint", newJBool(prettyPrint))
  add(query_580095, "oauth_token", newJString(oauthToken))
  add(query_580095, "$.xgafv", newJString(Xgafv))
  add(query_580095, "alt", newJString(alt))
  add(query_580095, "uploadType", newJString(uploadType))
  add(query_580095, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580096 = body
  add(query_580095, "callback", newJString(callback))
  add(path_580094, "parent", newJString(parent))
  add(query_580095, "fields", newJString(fields))
  add(query_580095, "access_token", newJString(accessToken))
  add(query_580095, "upload_protocol", newJString(uploadProtocol))
  result = call_580093.call(path_580094, query_580095, nil, nil, body_580096)

var dlpProjectsContentInspect* = Call_DlpProjectsContentInspect_580076(
    name: "dlpProjectsContentInspect", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/content:inspect",
    validator: validate_DlpProjectsContentInspect_580077, base: "/",
    url: url_DlpProjectsContentInspect_580078, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentReidentify_580097 = ref object of OpenApiRestCall_579373
proc url_DlpProjectsContentReidentify_580099(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/content:reidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpProjectsContentReidentify_580098(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580100 = path.getOrDefault("parent")
  valid_580100 = validateParameter(valid_580100, JString, required = true,
                                 default = nil)
  if valid_580100 != nil:
    section.add "parent", valid_580100
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
  var valid_580101 = query.getOrDefault("key")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "key", valid_580101
  var valid_580102 = query.getOrDefault("prettyPrint")
  valid_580102 = validateParameter(valid_580102, JBool, required = false,
                                 default = newJBool(true))
  if valid_580102 != nil:
    section.add "prettyPrint", valid_580102
  var valid_580103 = query.getOrDefault("oauth_token")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "oauth_token", valid_580103
  var valid_580104 = query.getOrDefault("$.xgafv")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = newJString("1"))
  if valid_580104 != nil:
    section.add "$.xgafv", valid_580104
  var valid_580105 = query.getOrDefault("alt")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = newJString("json"))
  if valid_580105 != nil:
    section.add "alt", valid_580105
  var valid_580106 = query.getOrDefault("uploadType")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "uploadType", valid_580106
  var valid_580107 = query.getOrDefault("quotaUser")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "quotaUser", valid_580107
  var valid_580108 = query.getOrDefault("callback")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "callback", valid_580108
  var valid_580109 = query.getOrDefault("fields")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "fields", valid_580109
  var valid_580110 = query.getOrDefault("access_token")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "access_token", valid_580110
  var valid_580111 = query.getOrDefault("upload_protocol")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "upload_protocol", valid_580111
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

proc call*(call_580113: Call_DlpProjectsContentReidentify_580097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
  ## 
  let valid = call_580113.validator(path, query, header, formData, body)
  let scheme = call_580113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580113.url(scheme.get, call_580113.host, call_580113.base,
                         call_580113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580113, url, valid)

proc call*(call_580114: Call_DlpProjectsContentReidentify_580097; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsContentReidentify
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
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
  ##   parent: string (required)
  ##         : Required. The parent resource name.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580115 = newJObject()
  var query_580116 = newJObject()
  var body_580117 = newJObject()
  add(query_580116, "key", newJString(key))
  add(query_580116, "prettyPrint", newJBool(prettyPrint))
  add(query_580116, "oauth_token", newJString(oauthToken))
  add(query_580116, "$.xgafv", newJString(Xgafv))
  add(query_580116, "alt", newJString(alt))
  add(query_580116, "uploadType", newJString(uploadType))
  add(query_580116, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580117 = body
  add(query_580116, "callback", newJString(callback))
  add(path_580115, "parent", newJString(parent))
  add(query_580116, "fields", newJString(fields))
  add(query_580116, "access_token", newJString(accessToken))
  add(query_580116, "upload_protocol", newJString(uploadProtocol))
  result = call_580114.call(path_580115, query_580116, nil, nil, body_580117)

var dlpProjectsContentReidentify* = Call_DlpProjectsContentReidentify_580097(
    name: "dlpProjectsContentReidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/content:reidentify",
    validator: validate_DlpProjectsContentReidentify_580098, base: "/",
    url: url_DlpProjectsContentReidentify_580099, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsDeidentifyTemplatesCreate_580140 = ref object of OpenApiRestCall_579373
proc url_DlpOrganizationsDeidentifyTemplatesCreate_580142(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/deidentifyTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpOrganizationsDeidentifyTemplatesCreate_580141(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a DeidentifyTemplate for re-using frequently used configuration
  ## for de-identifying content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580143 = path.getOrDefault("parent")
  valid_580143 = validateParameter(valid_580143, JString, required = true,
                                 default = nil)
  if valid_580143 != nil:
    section.add "parent", valid_580143
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
  var valid_580144 = query.getOrDefault("key")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "key", valid_580144
  var valid_580145 = query.getOrDefault("prettyPrint")
  valid_580145 = validateParameter(valid_580145, JBool, required = false,
                                 default = newJBool(true))
  if valid_580145 != nil:
    section.add "prettyPrint", valid_580145
  var valid_580146 = query.getOrDefault("oauth_token")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "oauth_token", valid_580146
  var valid_580147 = query.getOrDefault("$.xgafv")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = newJString("1"))
  if valid_580147 != nil:
    section.add "$.xgafv", valid_580147
  var valid_580148 = query.getOrDefault("alt")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = newJString("json"))
  if valid_580148 != nil:
    section.add "alt", valid_580148
  var valid_580149 = query.getOrDefault("uploadType")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "uploadType", valid_580149
  var valid_580150 = query.getOrDefault("quotaUser")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "quotaUser", valid_580150
  var valid_580151 = query.getOrDefault("callback")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "callback", valid_580151
  var valid_580152 = query.getOrDefault("fields")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "fields", valid_580152
  var valid_580153 = query.getOrDefault("access_token")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "access_token", valid_580153
  var valid_580154 = query.getOrDefault("upload_protocol")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "upload_protocol", valid_580154
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

proc call*(call_580156: Call_DlpOrganizationsDeidentifyTemplatesCreate_580140;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a DeidentifyTemplate for re-using frequently used configuration
  ## for de-identifying content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ## 
  let valid = call_580156.validator(path, query, header, formData, body)
  let scheme = call_580156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580156.url(scheme.get, call_580156.host, call_580156.base,
                         call_580156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580156, url, valid)

proc call*(call_580157: Call_DlpOrganizationsDeidentifyTemplatesCreate_580140;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpOrganizationsDeidentifyTemplatesCreate
  ## Creates a DeidentifyTemplate for re-using frequently used configuration
  ## for de-identifying content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
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
  ##   parent: string (required)
  ##         : Required. The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580158 = newJObject()
  var query_580159 = newJObject()
  var body_580160 = newJObject()
  add(query_580159, "key", newJString(key))
  add(query_580159, "prettyPrint", newJBool(prettyPrint))
  add(query_580159, "oauth_token", newJString(oauthToken))
  add(query_580159, "$.xgafv", newJString(Xgafv))
  add(query_580159, "alt", newJString(alt))
  add(query_580159, "uploadType", newJString(uploadType))
  add(query_580159, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580160 = body
  add(query_580159, "callback", newJString(callback))
  add(path_580158, "parent", newJString(parent))
  add(query_580159, "fields", newJString(fields))
  add(query_580159, "access_token", newJString(accessToken))
  add(query_580159, "upload_protocol", newJString(uploadProtocol))
  result = call_580157.call(path_580158, query_580159, nil, nil, body_580160)

var dlpOrganizationsDeidentifyTemplatesCreate* = Call_DlpOrganizationsDeidentifyTemplatesCreate_580140(
    name: "dlpOrganizationsDeidentifyTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/deidentifyTemplates",
    validator: validate_DlpOrganizationsDeidentifyTemplatesCreate_580141,
    base: "/", url: url_DlpOrganizationsDeidentifyTemplatesCreate_580142,
    schemes: {Scheme.Https})
type
  Call_DlpOrganizationsDeidentifyTemplatesList_580118 = ref object of OpenApiRestCall_579373
proc url_DlpOrganizationsDeidentifyTemplatesList_580120(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/deidentifyTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpOrganizationsDeidentifyTemplatesList_580119(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists DeidentifyTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580121 = path.getOrDefault("parent")
  valid_580121 = validateParameter(valid_580121, JString, required = true,
                                 default = nil)
  if valid_580121 != nil:
    section.add "parent", valid_580121
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
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc,update_time, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the template was created.
  ## - `update_time`: corresponds to time the template was last updated.
  ## - `name`: corresponds to template's name.
  ## - `display_name`: corresponds to template's display name.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListDeidentifyTemplates`.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580122 = query.getOrDefault("key")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "key", valid_580122
  var valid_580123 = query.getOrDefault("prettyPrint")
  valid_580123 = validateParameter(valid_580123, JBool, required = false,
                                 default = newJBool(true))
  if valid_580123 != nil:
    section.add "prettyPrint", valid_580123
  var valid_580124 = query.getOrDefault("oauth_token")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "oauth_token", valid_580124
  var valid_580125 = query.getOrDefault("$.xgafv")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = newJString("1"))
  if valid_580125 != nil:
    section.add "$.xgafv", valid_580125
  var valid_580126 = query.getOrDefault("pageSize")
  valid_580126 = validateParameter(valid_580126, JInt, required = false, default = nil)
  if valid_580126 != nil:
    section.add "pageSize", valid_580126
  var valid_580127 = query.getOrDefault("alt")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = newJString("json"))
  if valid_580127 != nil:
    section.add "alt", valid_580127
  var valid_580128 = query.getOrDefault("uploadType")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "uploadType", valid_580128
  var valid_580129 = query.getOrDefault("quotaUser")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "quotaUser", valid_580129
  var valid_580130 = query.getOrDefault("orderBy")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "orderBy", valid_580130
  var valid_580131 = query.getOrDefault("pageToken")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "pageToken", valid_580131
  var valid_580132 = query.getOrDefault("callback")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "callback", valid_580132
  var valid_580133 = query.getOrDefault("fields")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "fields", valid_580133
  var valid_580134 = query.getOrDefault("access_token")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "access_token", valid_580134
  var valid_580135 = query.getOrDefault("upload_protocol")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "upload_protocol", valid_580135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580136: Call_DlpOrganizationsDeidentifyTemplatesList_580118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists DeidentifyTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ## 
  let valid = call_580136.validator(path, query, header, formData, body)
  let scheme = call_580136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580136.url(scheme.get, call_580136.host, call_580136.base,
                         call_580136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580136, url, valid)

proc call*(call_580137: Call_DlpOrganizationsDeidentifyTemplatesList_580118;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          orderBy: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpOrganizationsDeidentifyTemplatesList
  ## Lists DeidentifyTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc,update_time, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the template was created.
  ## - `update_time`: corresponds to time the template was last updated.
  ## - `name`: corresponds to template's name.
  ## - `display_name`: corresponds to template's display name.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListDeidentifyTemplates`.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580138 = newJObject()
  var query_580139 = newJObject()
  add(query_580139, "key", newJString(key))
  add(query_580139, "prettyPrint", newJBool(prettyPrint))
  add(query_580139, "oauth_token", newJString(oauthToken))
  add(query_580139, "$.xgafv", newJString(Xgafv))
  add(query_580139, "pageSize", newJInt(pageSize))
  add(query_580139, "alt", newJString(alt))
  add(query_580139, "uploadType", newJString(uploadType))
  add(query_580139, "quotaUser", newJString(quotaUser))
  add(query_580139, "orderBy", newJString(orderBy))
  add(query_580139, "pageToken", newJString(pageToken))
  add(query_580139, "callback", newJString(callback))
  add(path_580138, "parent", newJString(parent))
  add(query_580139, "fields", newJString(fields))
  add(query_580139, "access_token", newJString(accessToken))
  add(query_580139, "upload_protocol", newJString(uploadProtocol))
  result = call_580137.call(path_580138, query_580139, nil, nil, nil)

var dlpOrganizationsDeidentifyTemplatesList* = Call_DlpOrganizationsDeidentifyTemplatesList_580118(
    name: "dlpOrganizationsDeidentifyTemplatesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/deidentifyTemplates",
    validator: validate_DlpOrganizationsDeidentifyTemplatesList_580119, base: "/",
    url: url_DlpOrganizationsDeidentifyTemplatesList_580120,
    schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsCreate_580185 = ref object of OpenApiRestCall_579373
proc url_DlpProjectsDlpJobsCreate_580187(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dlpJobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpProjectsDlpJobsCreate_580186(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new job to inspect storage or calculate risk metrics.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in inspect jobs, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580188 = path.getOrDefault("parent")
  valid_580188 = validateParameter(valid_580188, JString, required = true,
                                 default = nil)
  if valid_580188 != nil:
    section.add "parent", valid_580188
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
  var valid_580189 = query.getOrDefault("key")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "key", valid_580189
  var valid_580190 = query.getOrDefault("prettyPrint")
  valid_580190 = validateParameter(valid_580190, JBool, required = false,
                                 default = newJBool(true))
  if valid_580190 != nil:
    section.add "prettyPrint", valid_580190
  var valid_580191 = query.getOrDefault("oauth_token")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "oauth_token", valid_580191
  var valid_580192 = query.getOrDefault("$.xgafv")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = newJString("1"))
  if valid_580192 != nil:
    section.add "$.xgafv", valid_580192
  var valid_580193 = query.getOrDefault("alt")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = newJString("json"))
  if valid_580193 != nil:
    section.add "alt", valid_580193
  var valid_580194 = query.getOrDefault("uploadType")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "uploadType", valid_580194
  var valid_580195 = query.getOrDefault("quotaUser")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "quotaUser", valid_580195
  var valid_580196 = query.getOrDefault("callback")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "callback", valid_580196
  var valid_580197 = query.getOrDefault("fields")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "fields", valid_580197
  var valid_580198 = query.getOrDefault("access_token")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "access_token", valid_580198
  var valid_580199 = query.getOrDefault("upload_protocol")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "upload_protocol", valid_580199
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

proc call*(call_580201: Call_DlpProjectsDlpJobsCreate_580185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new job to inspect storage or calculate risk metrics.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in inspect jobs, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  let valid = call_580201.validator(path, query, header, formData, body)
  let scheme = call_580201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580201.url(scheme.get, call_580201.host, call_580201.base,
                         call_580201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580201, url, valid)

proc call*(call_580202: Call_DlpProjectsDlpJobsCreate_580185; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsDlpJobsCreate
  ## Creates a new job to inspect storage or calculate risk metrics.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in inspect jobs, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
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
  ##   parent: string (required)
  ##         : Required. The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580203 = newJObject()
  var query_580204 = newJObject()
  var body_580205 = newJObject()
  add(query_580204, "key", newJString(key))
  add(query_580204, "prettyPrint", newJBool(prettyPrint))
  add(query_580204, "oauth_token", newJString(oauthToken))
  add(query_580204, "$.xgafv", newJString(Xgafv))
  add(query_580204, "alt", newJString(alt))
  add(query_580204, "uploadType", newJString(uploadType))
  add(query_580204, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580205 = body
  add(query_580204, "callback", newJString(callback))
  add(path_580203, "parent", newJString(parent))
  add(query_580204, "fields", newJString(fields))
  add(query_580204, "access_token", newJString(accessToken))
  add(query_580204, "upload_protocol", newJString(uploadProtocol))
  result = call_580202.call(path_580203, query_580204, nil, nil, body_580205)

var dlpProjectsDlpJobsCreate* = Call_DlpProjectsDlpJobsCreate_580185(
    name: "dlpProjectsDlpJobsCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/dlpJobs",
    validator: validate_DlpProjectsDlpJobsCreate_580186, base: "/",
    url: url_DlpProjectsDlpJobsCreate_580187, schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsList_580161 = ref object of OpenApiRestCall_579373
proc url_DlpProjectsDlpJobsList_580163(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dlpJobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpProjectsDlpJobsList_580162(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists DlpJobs that match the specified filter in the request.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580164 = path.getOrDefault("parent")
  valid_580164 = validateParameter(valid_580164, JString, required = true,
                                 default = nil)
  if valid_580164 != nil:
    section.add "parent", valid_580164
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
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc, end_time asc, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the job was created.
  ## - `end_time`: corresponds to time the job ended.
  ## - `name`: corresponds to job's name.
  ## - `state`: corresponds to `state`
  ##   type: JString
  ##       : The type of job. Defaults to `DlpJobType.INSPECT`
  ##   filter: JString
  ##         : Optional. Allows filtering.
  ## 
  ## Supported syntax:
  ## 
  ## * Filter expressions are made up of one or more restrictions.
  ## * Restrictions can be combined by `AND` or `OR` logical operators. A
  ## sequence of restrictions implicitly uses `AND`.
  ## * A restriction has the form of `<field> <operator> <value>`.
  ## * Supported fields/values for inspect jobs:
  ##     - `state` - PENDING|RUNNING|CANCELED|FINISHED|FAILED
  ##     - `inspected_storage` - DATASTORE|CLOUD_STORAGE|BIGQUERY
  ##     - `trigger_name` - The resource name of the trigger that created job.
  ##     - 'end_time` - Corresponds to time the job finished.
  ##     - 'start_time` - Corresponds to time the job finished.
  ## * Supported fields for risk analysis jobs:
  ##     - `state` - RUNNING|CANCELED|FINISHED|FAILED
  ##     - 'end_time` - Corresponds to time the job finished.
  ##     - 'start_time` - Corresponds to time the job finished.
  ## * The operator must be `=` or `!=`.
  ## 
  ## Examples:
  ## 
  ## * inspected_storage = cloud_storage AND state = done
  ## * inspected_storage = cloud_storage OR inspected_storage = bigquery
  ## * inspected_storage = cloud_storage AND (state = done OR state = canceled)
  ## * end_time > \"2017-12-12T00:00:00+00:00\"
  ## 
  ## The length of this field should be no more than 500 characters.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580165 = query.getOrDefault("key")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "key", valid_580165
  var valid_580166 = query.getOrDefault("prettyPrint")
  valid_580166 = validateParameter(valid_580166, JBool, required = false,
                                 default = newJBool(true))
  if valid_580166 != nil:
    section.add "prettyPrint", valid_580166
  var valid_580167 = query.getOrDefault("oauth_token")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "oauth_token", valid_580167
  var valid_580168 = query.getOrDefault("$.xgafv")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = newJString("1"))
  if valid_580168 != nil:
    section.add "$.xgafv", valid_580168
  var valid_580169 = query.getOrDefault("pageSize")
  valid_580169 = validateParameter(valid_580169, JInt, required = false, default = nil)
  if valid_580169 != nil:
    section.add "pageSize", valid_580169
  var valid_580170 = query.getOrDefault("alt")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = newJString("json"))
  if valid_580170 != nil:
    section.add "alt", valid_580170
  var valid_580171 = query.getOrDefault("uploadType")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "uploadType", valid_580171
  var valid_580172 = query.getOrDefault("quotaUser")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "quotaUser", valid_580172
  var valid_580173 = query.getOrDefault("orderBy")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "orderBy", valid_580173
  var valid_580174 = query.getOrDefault("type")
  valid_580174 = validateParameter(valid_580174, JString, required = false, default = newJString(
      "DLP_JOB_TYPE_UNSPECIFIED"))
  if valid_580174 != nil:
    section.add "type", valid_580174
  var valid_580175 = query.getOrDefault("filter")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "filter", valid_580175
  var valid_580176 = query.getOrDefault("pageToken")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "pageToken", valid_580176
  var valid_580177 = query.getOrDefault("callback")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "callback", valid_580177
  var valid_580178 = query.getOrDefault("fields")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "fields", valid_580178
  var valid_580179 = query.getOrDefault("access_token")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "access_token", valid_580179
  var valid_580180 = query.getOrDefault("upload_protocol")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "upload_protocol", valid_580180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580181: Call_DlpProjectsDlpJobsList_580161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists DlpJobs that match the specified filter in the request.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  let valid = call_580181.validator(path, query, header, formData, body)
  let scheme = call_580181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580181.url(scheme.get, call_580181.host, call_580181.base,
                         call_580181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580181, url, valid)

proc call*(call_580182: Call_DlpProjectsDlpJobsList_580161; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; orderBy: string = "";
          `type`: string = "DLP_JOB_TYPE_UNSPECIFIED"; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsDlpJobsList
  ## Lists DlpJobs that match the specified filter in the request.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc, end_time asc, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the job was created.
  ## - `end_time`: corresponds to time the job ended.
  ## - `name`: corresponds to job's name.
  ## - `state`: corresponds to `state`
  ##   type: string
  ##       : The type of job. Defaults to `DlpJobType.INSPECT`
  ##   filter: string
  ##         : Optional. Allows filtering.
  ## 
  ## Supported syntax:
  ## 
  ## * Filter expressions are made up of one or more restrictions.
  ## * Restrictions can be combined by `AND` or `OR` logical operators. A
  ## sequence of restrictions implicitly uses `AND`.
  ## * A restriction has the form of `<field> <operator> <value>`.
  ## * Supported fields/values for inspect jobs:
  ##     - `state` - PENDING|RUNNING|CANCELED|FINISHED|FAILED
  ##     - `inspected_storage` - DATASTORE|CLOUD_STORAGE|BIGQUERY
  ##     - `trigger_name` - The resource name of the trigger that created job.
  ##     - 'end_time` - Corresponds to time the job finished.
  ##     - 'start_time` - Corresponds to time the job finished.
  ## * Supported fields for risk analysis jobs:
  ##     - `state` - RUNNING|CANCELED|FINISHED|FAILED
  ##     - 'end_time` - Corresponds to time the job finished.
  ##     - 'start_time` - Corresponds to time the job finished.
  ## * The operator must be `=` or `!=`.
  ## 
  ## Examples:
  ## 
  ## * inspected_storage = cloud_storage AND state = done
  ## * inspected_storage = cloud_storage OR inspected_storage = bigquery
  ## * inspected_storage = cloud_storage AND (state = done OR state = canceled)
  ## * end_time > \"2017-12-12T00:00:00+00:00\"
  ## 
  ## The length of this field should be no more than 500 characters.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580183 = newJObject()
  var query_580184 = newJObject()
  add(query_580184, "key", newJString(key))
  add(query_580184, "prettyPrint", newJBool(prettyPrint))
  add(query_580184, "oauth_token", newJString(oauthToken))
  add(query_580184, "$.xgafv", newJString(Xgafv))
  add(query_580184, "pageSize", newJInt(pageSize))
  add(query_580184, "alt", newJString(alt))
  add(query_580184, "uploadType", newJString(uploadType))
  add(query_580184, "quotaUser", newJString(quotaUser))
  add(query_580184, "orderBy", newJString(orderBy))
  add(query_580184, "type", newJString(`type`))
  add(query_580184, "filter", newJString(filter))
  add(query_580184, "pageToken", newJString(pageToken))
  add(query_580184, "callback", newJString(callback))
  add(path_580183, "parent", newJString(parent))
  add(query_580184, "fields", newJString(fields))
  add(query_580184, "access_token", newJString(accessToken))
  add(query_580184, "upload_protocol", newJString(uploadProtocol))
  result = call_580182.call(path_580183, query_580184, nil, nil, nil)

var dlpProjectsDlpJobsList* = Call_DlpProjectsDlpJobsList_580161(
    name: "dlpProjectsDlpJobsList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/dlpJobs",
    validator: validate_DlpProjectsDlpJobsList_580162, base: "/",
    url: url_DlpProjectsDlpJobsList_580163, schemes: {Scheme.Https})
type
  Call_DlpProjectsImageRedact_580206 = ref object of OpenApiRestCall_579373
proc url_DlpProjectsImageRedact_580208(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/image:redact")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpProjectsImageRedact_580207(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## See https://cloud.google.com/dlp/docs/redacting-sensitive-data-images to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580209 = path.getOrDefault("parent")
  valid_580209 = validateParameter(valid_580209, JString, required = true,
                                 default = nil)
  if valid_580209 != nil:
    section.add "parent", valid_580209
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
  var valid_580210 = query.getOrDefault("key")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "key", valid_580210
  var valid_580211 = query.getOrDefault("prettyPrint")
  valid_580211 = validateParameter(valid_580211, JBool, required = false,
                                 default = newJBool(true))
  if valid_580211 != nil:
    section.add "prettyPrint", valid_580211
  var valid_580212 = query.getOrDefault("oauth_token")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "oauth_token", valid_580212
  var valid_580213 = query.getOrDefault("$.xgafv")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = newJString("1"))
  if valid_580213 != nil:
    section.add "$.xgafv", valid_580213
  var valid_580214 = query.getOrDefault("alt")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = newJString("json"))
  if valid_580214 != nil:
    section.add "alt", valid_580214
  var valid_580215 = query.getOrDefault("uploadType")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "uploadType", valid_580215
  var valid_580216 = query.getOrDefault("quotaUser")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "quotaUser", valid_580216
  var valid_580217 = query.getOrDefault("callback")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "callback", valid_580217
  var valid_580218 = query.getOrDefault("fields")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "fields", valid_580218
  var valid_580219 = query.getOrDefault("access_token")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "access_token", valid_580219
  var valid_580220 = query.getOrDefault("upload_protocol")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "upload_protocol", valid_580220
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

proc call*(call_580222: Call_DlpProjectsImageRedact_580206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## See https://cloud.google.com/dlp/docs/redacting-sensitive-data-images to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  let valid = call_580222.validator(path, query, header, formData, body)
  let scheme = call_580222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580222.url(scheme.get, call_580222.host, call_580222.base,
                         call_580222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580222, url, valid)

proc call*(call_580223: Call_DlpProjectsImageRedact_580206; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsImageRedact
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## See https://cloud.google.com/dlp/docs/redacting-sensitive-data-images to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
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
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580224 = newJObject()
  var query_580225 = newJObject()
  var body_580226 = newJObject()
  add(query_580225, "key", newJString(key))
  add(query_580225, "prettyPrint", newJBool(prettyPrint))
  add(query_580225, "oauth_token", newJString(oauthToken))
  add(query_580225, "$.xgafv", newJString(Xgafv))
  add(query_580225, "alt", newJString(alt))
  add(query_580225, "uploadType", newJString(uploadType))
  add(query_580225, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580226 = body
  add(query_580225, "callback", newJString(callback))
  add(path_580224, "parent", newJString(parent))
  add(query_580225, "fields", newJString(fields))
  add(query_580225, "access_token", newJString(accessToken))
  add(query_580225, "upload_protocol", newJString(uploadProtocol))
  result = call_580223.call(path_580224, query_580225, nil, nil, body_580226)

var dlpProjectsImageRedact* = Call_DlpProjectsImageRedact_580206(
    name: "dlpProjectsImageRedact", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/image:redact",
    validator: validate_DlpProjectsImageRedact_580207, base: "/",
    url: url_DlpProjectsImageRedact_580208, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsInspectTemplatesCreate_580249 = ref object of OpenApiRestCall_579373
proc url_DlpOrganizationsInspectTemplatesCreate_580251(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/inspectTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpOrganizationsInspectTemplatesCreate_580250(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an InspectTemplate for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580252 = path.getOrDefault("parent")
  valid_580252 = validateParameter(valid_580252, JString, required = true,
                                 default = nil)
  if valid_580252 != nil:
    section.add "parent", valid_580252
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
  var valid_580253 = query.getOrDefault("key")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "key", valid_580253
  var valid_580254 = query.getOrDefault("prettyPrint")
  valid_580254 = validateParameter(valid_580254, JBool, required = false,
                                 default = newJBool(true))
  if valid_580254 != nil:
    section.add "prettyPrint", valid_580254
  var valid_580255 = query.getOrDefault("oauth_token")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "oauth_token", valid_580255
  var valid_580256 = query.getOrDefault("$.xgafv")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = newJString("1"))
  if valid_580256 != nil:
    section.add "$.xgafv", valid_580256
  var valid_580257 = query.getOrDefault("alt")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = newJString("json"))
  if valid_580257 != nil:
    section.add "alt", valid_580257
  var valid_580258 = query.getOrDefault("uploadType")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "uploadType", valid_580258
  var valid_580259 = query.getOrDefault("quotaUser")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "quotaUser", valid_580259
  var valid_580260 = query.getOrDefault("callback")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "callback", valid_580260
  var valid_580261 = query.getOrDefault("fields")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "fields", valid_580261
  var valid_580262 = query.getOrDefault("access_token")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "access_token", valid_580262
  var valid_580263 = query.getOrDefault("upload_protocol")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "upload_protocol", valid_580263
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

proc call*(call_580265: Call_DlpOrganizationsInspectTemplatesCreate_580249;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an InspectTemplate for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  let valid = call_580265.validator(path, query, header, formData, body)
  let scheme = call_580265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580265.url(scheme.get, call_580265.host, call_580265.base,
                         call_580265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580265, url, valid)

proc call*(call_580266: Call_DlpOrganizationsInspectTemplatesCreate_580249;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpOrganizationsInspectTemplatesCreate
  ## Creates an InspectTemplate for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
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
  ##   parent: string (required)
  ##         : Required. The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580267 = newJObject()
  var query_580268 = newJObject()
  var body_580269 = newJObject()
  add(query_580268, "key", newJString(key))
  add(query_580268, "prettyPrint", newJBool(prettyPrint))
  add(query_580268, "oauth_token", newJString(oauthToken))
  add(query_580268, "$.xgafv", newJString(Xgafv))
  add(query_580268, "alt", newJString(alt))
  add(query_580268, "uploadType", newJString(uploadType))
  add(query_580268, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580269 = body
  add(query_580268, "callback", newJString(callback))
  add(path_580267, "parent", newJString(parent))
  add(query_580268, "fields", newJString(fields))
  add(query_580268, "access_token", newJString(accessToken))
  add(query_580268, "upload_protocol", newJString(uploadProtocol))
  result = call_580266.call(path_580267, query_580268, nil, nil, body_580269)

var dlpOrganizationsInspectTemplatesCreate* = Call_DlpOrganizationsInspectTemplatesCreate_580249(
    name: "dlpOrganizationsInspectTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/inspectTemplates",
    validator: validate_DlpOrganizationsInspectTemplatesCreate_580250, base: "/",
    url: url_DlpOrganizationsInspectTemplatesCreate_580251,
    schemes: {Scheme.Https})
type
  Call_DlpOrganizationsInspectTemplatesList_580227 = ref object of OpenApiRestCall_579373
proc url_DlpOrganizationsInspectTemplatesList_580229(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/inspectTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpOrganizationsInspectTemplatesList_580228(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists InspectTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580230 = path.getOrDefault("parent")
  valid_580230 = validateParameter(valid_580230, JString, required = true,
                                 default = nil)
  if valid_580230 != nil:
    section.add "parent", valid_580230
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
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc,update_time, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the template was created.
  ## - `update_time`: corresponds to time the template was last updated.
  ## - `name`: corresponds to template's name.
  ## - `display_name`: corresponds to template's display name.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListInspectTemplates`.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580231 = query.getOrDefault("key")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "key", valid_580231
  var valid_580232 = query.getOrDefault("prettyPrint")
  valid_580232 = validateParameter(valid_580232, JBool, required = false,
                                 default = newJBool(true))
  if valid_580232 != nil:
    section.add "prettyPrint", valid_580232
  var valid_580233 = query.getOrDefault("oauth_token")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "oauth_token", valid_580233
  var valid_580234 = query.getOrDefault("$.xgafv")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = newJString("1"))
  if valid_580234 != nil:
    section.add "$.xgafv", valid_580234
  var valid_580235 = query.getOrDefault("pageSize")
  valid_580235 = validateParameter(valid_580235, JInt, required = false, default = nil)
  if valid_580235 != nil:
    section.add "pageSize", valid_580235
  var valid_580236 = query.getOrDefault("alt")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = newJString("json"))
  if valid_580236 != nil:
    section.add "alt", valid_580236
  var valid_580237 = query.getOrDefault("uploadType")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "uploadType", valid_580237
  var valid_580238 = query.getOrDefault("quotaUser")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "quotaUser", valid_580238
  var valid_580239 = query.getOrDefault("orderBy")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "orderBy", valid_580239
  var valid_580240 = query.getOrDefault("pageToken")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "pageToken", valid_580240
  var valid_580241 = query.getOrDefault("callback")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "callback", valid_580241
  var valid_580242 = query.getOrDefault("fields")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "fields", valid_580242
  var valid_580243 = query.getOrDefault("access_token")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "access_token", valid_580243
  var valid_580244 = query.getOrDefault("upload_protocol")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "upload_protocol", valid_580244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580245: Call_DlpOrganizationsInspectTemplatesList_580227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists InspectTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  let valid = call_580245.validator(path, query, header, formData, body)
  let scheme = call_580245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580245.url(scheme.get, call_580245.host, call_580245.base,
                         call_580245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580245, url, valid)

proc call*(call_580246: Call_DlpOrganizationsInspectTemplatesList_580227;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          orderBy: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpOrganizationsInspectTemplatesList
  ## Lists InspectTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc,update_time, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the template was created.
  ## - `update_time`: corresponds to time the template was last updated.
  ## - `name`: corresponds to template's name.
  ## - `display_name`: corresponds to template's display name.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListInspectTemplates`.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580247 = newJObject()
  var query_580248 = newJObject()
  add(query_580248, "key", newJString(key))
  add(query_580248, "prettyPrint", newJBool(prettyPrint))
  add(query_580248, "oauth_token", newJString(oauthToken))
  add(query_580248, "$.xgafv", newJString(Xgafv))
  add(query_580248, "pageSize", newJInt(pageSize))
  add(query_580248, "alt", newJString(alt))
  add(query_580248, "uploadType", newJString(uploadType))
  add(query_580248, "quotaUser", newJString(quotaUser))
  add(query_580248, "orderBy", newJString(orderBy))
  add(query_580248, "pageToken", newJString(pageToken))
  add(query_580248, "callback", newJString(callback))
  add(path_580247, "parent", newJString(parent))
  add(query_580248, "fields", newJString(fields))
  add(query_580248, "access_token", newJString(accessToken))
  add(query_580248, "upload_protocol", newJString(uploadProtocol))
  result = call_580246.call(path_580247, query_580248, nil, nil, nil)

var dlpOrganizationsInspectTemplatesList* = Call_DlpOrganizationsInspectTemplatesList_580227(
    name: "dlpOrganizationsInspectTemplatesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/inspectTemplates",
    validator: validate_DlpOrganizationsInspectTemplatesList_580228, base: "/",
    url: url_DlpOrganizationsInspectTemplatesList_580229, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersCreate_580293 = ref object of OpenApiRestCall_579373
proc url_DlpProjectsJobTriggersCreate_580295(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobTriggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersCreate_580294(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a job trigger to run DLP actions such as scanning storage for
  ## sensitive information on a set schedule.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580296 = path.getOrDefault("parent")
  valid_580296 = validateParameter(valid_580296, JString, required = true,
                                 default = nil)
  if valid_580296 != nil:
    section.add "parent", valid_580296
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
  var valid_580297 = query.getOrDefault("key")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "key", valid_580297
  var valid_580298 = query.getOrDefault("prettyPrint")
  valid_580298 = validateParameter(valid_580298, JBool, required = false,
                                 default = newJBool(true))
  if valid_580298 != nil:
    section.add "prettyPrint", valid_580298
  var valid_580299 = query.getOrDefault("oauth_token")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "oauth_token", valid_580299
  var valid_580300 = query.getOrDefault("$.xgafv")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = newJString("1"))
  if valid_580300 != nil:
    section.add "$.xgafv", valid_580300
  var valid_580301 = query.getOrDefault("alt")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = newJString("json"))
  if valid_580301 != nil:
    section.add "alt", valid_580301
  var valid_580302 = query.getOrDefault("uploadType")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "uploadType", valid_580302
  var valid_580303 = query.getOrDefault("quotaUser")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "quotaUser", valid_580303
  var valid_580304 = query.getOrDefault("callback")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "callback", valid_580304
  var valid_580305 = query.getOrDefault("fields")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "fields", valid_580305
  var valid_580306 = query.getOrDefault("access_token")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "access_token", valid_580306
  var valid_580307 = query.getOrDefault("upload_protocol")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "upload_protocol", valid_580307
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

proc call*(call_580309: Call_DlpProjectsJobTriggersCreate_580293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a job trigger to run DLP actions such as scanning storage for
  ## sensitive information on a set schedule.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ## 
  let valid = call_580309.validator(path, query, header, formData, body)
  let scheme = call_580309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580309.url(scheme.get, call_580309.host, call_580309.base,
                         call_580309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580309, url, valid)

proc call*(call_580310: Call_DlpProjectsJobTriggersCreate_580293; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsJobTriggersCreate
  ## Creates a job trigger to run DLP actions such as scanning storage for
  ## sensitive information on a set schedule.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
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
  ##   parent: string (required)
  ##         : Required. The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580311 = newJObject()
  var query_580312 = newJObject()
  var body_580313 = newJObject()
  add(query_580312, "key", newJString(key))
  add(query_580312, "prettyPrint", newJBool(prettyPrint))
  add(query_580312, "oauth_token", newJString(oauthToken))
  add(query_580312, "$.xgafv", newJString(Xgafv))
  add(query_580312, "alt", newJString(alt))
  add(query_580312, "uploadType", newJString(uploadType))
  add(query_580312, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580313 = body
  add(query_580312, "callback", newJString(callback))
  add(path_580311, "parent", newJString(parent))
  add(query_580312, "fields", newJString(fields))
  add(query_580312, "access_token", newJString(accessToken))
  add(query_580312, "upload_protocol", newJString(uploadProtocol))
  result = call_580310.call(path_580311, query_580312, nil, nil, body_580313)

var dlpProjectsJobTriggersCreate* = Call_DlpProjectsJobTriggersCreate_580293(
    name: "dlpProjectsJobTriggersCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/jobTriggers",
    validator: validate_DlpProjectsJobTriggersCreate_580294, base: "/",
    url: url_DlpProjectsJobTriggersCreate_580295, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersList_580270 = ref object of OpenApiRestCall_579373
proc url_DlpProjectsJobTriggersList_580272(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobTriggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersList_580271(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists job triggers.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource name, for example `projects/my-project-id`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580273 = path.getOrDefault("parent")
  valid_580273 = validateParameter(valid_580273, JString, required = true,
                                 default = nil)
  if valid_580273 != nil:
    section.add "parent", valid_580273
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
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by a server.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Optional comma separated list of triggeredJob fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc,update_time, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the JobTrigger was created.
  ## - `update_time`: corresponds to time the JobTrigger was last updated.
  ## - `last_run_time`: corresponds to the last time the JobTrigger ran.
  ## - `name`: corresponds to JobTrigger's name.
  ## - `display_name`: corresponds to JobTrigger's display name.
  ## - `status`: corresponds to JobTrigger's status.
  ##   filter: JString
  ##         : Optional. Allows filtering.
  ## 
  ## Supported syntax:
  ## 
  ## * Filter expressions are made up of one or more restrictions.
  ## * Restrictions can be combined by `AND` or `OR` logical operators. A
  ## sequence of restrictions implicitly uses `AND`.
  ## * A restriction has the form of `<field> <operator> <value>`.
  ## * Supported fields/values for inspect jobs:
  ##     - `status` - HEALTHY|PAUSED|CANCELLED
  ##     - `inspected_storage` - DATASTORE|CLOUD_STORAGE|BIGQUERY
  ##     - 'last_run_time` - RFC 3339 formatted timestamp, surrounded by
  ##     quotation marks. Nanoseconds are ignored.
  ##     - 'error_count' - Number of errors that have occurred while running.
  ## * The operator must be `=` or `!=` for status and inspected_storage.
  ## 
  ## Examples:
  ## 
  ## * inspected_storage = cloud_storage AND status = HEALTHY
  ## * inspected_storage = cloud_storage OR inspected_storage = bigquery
  ## * inspected_storage = cloud_storage AND (state = PAUSED OR state = HEALTHY)
  ## * last_run_time > \"2017-12-12T00:00:00+00:00\"
  ## 
  ## The length of this field should be no more than 500 characters.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to ListJobTriggers. `order_by` field must not
  ## change for subsequent calls.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580274 = query.getOrDefault("key")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "key", valid_580274
  var valid_580275 = query.getOrDefault("prettyPrint")
  valid_580275 = validateParameter(valid_580275, JBool, required = false,
                                 default = newJBool(true))
  if valid_580275 != nil:
    section.add "prettyPrint", valid_580275
  var valid_580276 = query.getOrDefault("oauth_token")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "oauth_token", valid_580276
  var valid_580277 = query.getOrDefault("$.xgafv")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = newJString("1"))
  if valid_580277 != nil:
    section.add "$.xgafv", valid_580277
  var valid_580278 = query.getOrDefault("pageSize")
  valid_580278 = validateParameter(valid_580278, JInt, required = false, default = nil)
  if valid_580278 != nil:
    section.add "pageSize", valid_580278
  var valid_580279 = query.getOrDefault("alt")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = newJString("json"))
  if valid_580279 != nil:
    section.add "alt", valid_580279
  var valid_580280 = query.getOrDefault("uploadType")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "uploadType", valid_580280
  var valid_580281 = query.getOrDefault("quotaUser")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "quotaUser", valid_580281
  var valid_580282 = query.getOrDefault("orderBy")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "orderBy", valid_580282
  var valid_580283 = query.getOrDefault("filter")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "filter", valid_580283
  var valid_580284 = query.getOrDefault("pageToken")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "pageToken", valid_580284
  var valid_580285 = query.getOrDefault("callback")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "callback", valid_580285
  var valid_580286 = query.getOrDefault("fields")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "fields", valid_580286
  var valid_580287 = query.getOrDefault("access_token")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "access_token", valid_580287
  var valid_580288 = query.getOrDefault("upload_protocol")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "upload_protocol", valid_580288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580289: Call_DlpProjectsJobTriggersList_580270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists job triggers.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ## 
  let valid = call_580289.validator(path, query, header, formData, body)
  let scheme = call_580289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580289.url(scheme.get, call_580289.host, call_580289.base,
                         call_580289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580289, url, valid)

proc call*(call_580290: Call_DlpProjectsJobTriggersList_580270; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; orderBy: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpProjectsJobTriggersList
  ## Lists job triggers.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by a server.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Optional comma separated list of triggeredJob fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc,update_time, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the JobTrigger was created.
  ## - `update_time`: corresponds to time the JobTrigger was last updated.
  ## - `last_run_time`: corresponds to the last time the JobTrigger ran.
  ## - `name`: corresponds to JobTrigger's name.
  ## - `display_name`: corresponds to JobTrigger's display name.
  ## - `status`: corresponds to JobTrigger's status.
  ##   filter: string
  ##         : Optional. Allows filtering.
  ## 
  ## Supported syntax:
  ## 
  ## * Filter expressions are made up of one or more restrictions.
  ## * Restrictions can be combined by `AND` or `OR` logical operators. A
  ## sequence of restrictions implicitly uses `AND`.
  ## * A restriction has the form of `<field> <operator> <value>`.
  ## * Supported fields/values for inspect jobs:
  ##     - `status` - HEALTHY|PAUSED|CANCELLED
  ##     - `inspected_storage` - DATASTORE|CLOUD_STORAGE|BIGQUERY
  ##     - 'last_run_time` - RFC 3339 formatted timestamp, surrounded by
  ##     quotation marks. Nanoseconds are ignored.
  ##     - 'error_count' - Number of errors that have occurred while running.
  ## * The operator must be `=` or `!=` for status and inspected_storage.
  ## 
  ## Examples:
  ## 
  ## * inspected_storage = cloud_storage AND status = HEALTHY
  ## * inspected_storage = cloud_storage OR inspected_storage = bigquery
  ## * inspected_storage = cloud_storage AND (state = PAUSED OR state = HEALTHY)
  ## * last_run_time > \"2017-12-12T00:00:00+00:00\"
  ## 
  ## The length of this field should be no more than 500 characters.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to ListJobTriggers. `order_by` field must not
  ## change for subsequent calls.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The parent resource name, for example `projects/my-project-id`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580291 = newJObject()
  var query_580292 = newJObject()
  add(query_580292, "key", newJString(key))
  add(query_580292, "prettyPrint", newJBool(prettyPrint))
  add(query_580292, "oauth_token", newJString(oauthToken))
  add(query_580292, "$.xgafv", newJString(Xgafv))
  add(query_580292, "pageSize", newJInt(pageSize))
  add(query_580292, "alt", newJString(alt))
  add(query_580292, "uploadType", newJString(uploadType))
  add(query_580292, "quotaUser", newJString(quotaUser))
  add(query_580292, "orderBy", newJString(orderBy))
  add(query_580292, "filter", newJString(filter))
  add(query_580292, "pageToken", newJString(pageToken))
  add(query_580292, "callback", newJString(callback))
  add(path_580291, "parent", newJString(parent))
  add(query_580292, "fields", newJString(fields))
  add(query_580292, "access_token", newJString(accessToken))
  add(query_580292, "upload_protocol", newJString(uploadProtocol))
  result = call_580290.call(path_580291, query_580292, nil, nil, nil)

var dlpProjectsJobTriggersList* = Call_DlpProjectsJobTriggersList_580270(
    name: "dlpProjectsJobTriggersList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/jobTriggers",
    validator: validate_DlpProjectsJobTriggersList_580271, base: "/",
    url: url_DlpProjectsJobTriggersList_580272, schemes: {Scheme.Https})
type
  Call_DlpProjectsLocationsContentDeidentify_580314 = ref object of OpenApiRestCall_579373
proc url_DlpProjectsLocationsContentDeidentify_580316(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/content:deidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpProjectsLocationsContentDeidentify_580315(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   location: JString (required)
  ##           : The geographic location to process de-identification. Reserved for future
  ## extensions.
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `location` field"
  var valid_580317 = path.getOrDefault("location")
  valid_580317 = validateParameter(valid_580317, JString, required = true,
                                 default = nil)
  if valid_580317 != nil:
    section.add "location", valid_580317
  var valid_580318 = path.getOrDefault("parent")
  valid_580318 = validateParameter(valid_580318, JString, required = true,
                                 default = nil)
  if valid_580318 != nil:
    section.add "parent", valid_580318
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
  var valid_580319 = query.getOrDefault("key")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "key", valid_580319
  var valid_580320 = query.getOrDefault("prettyPrint")
  valid_580320 = validateParameter(valid_580320, JBool, required = false,
                                 default = newJBool(true))
  if valid_580320 != nil:
    section.add "prettyPrint", valid_580320
  var valid_580321 = query.getOrDefault("oauth_token")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "oauth_token", valid_580321
  var valid_580322 = query.getOrDefault("$.xgafv")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = newJString("1"))
  if valid_580322 != nil:
    section.add "$.xgafv", valid_580322
  var valid_580323 = query.getOrDefault("alt")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = newJString("json"))
  if valid_580323 != nil:
    section.add "alt", valid_580323
  var valid_580324 = query.getOrDefault("uploadType")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "uploadType", valid_580324
  var valid_580325 = query.getOrDefault("quotaUser")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "quotaUser", valid_580325
  var valid_580326 = query.getOrDefault("callback")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "callback", valid_580326
  var valid_580327 = query.getOrDefault("fields")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "fields", valid_580327
  var valid_580328 = query.getOrDefault("access_token")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "access_token", valid_580328
  var valid_580329 = query.getOrDefault("upload_protocol")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "upload_protocol", valid_580329
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

proc call*(call_580331: Call_DlpProjectsLocationsContentDeidentify_580314;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  let valid = call_580331.validator(path, query, header, formData, body)
  let scheme = call_580331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580331.url(scheme.get, call_580331.host, call_580331.base,
                         call_580331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580331, url, valid)

proc call*(call_580332: Call_DlpProjectsLocationsContentDeidentify_580314;
          location: string; parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpProjectsLocationsContentDeidentify
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
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
  ##   location: string (required)
  ##           : The geographic location to process de-identification. Reserved for future
  ## extensions.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580333 = newJObject()
  var query_580334 = newJObject()
  var body_580335 = newJObject()
  add(query_580334, "key", newJString(key))
  add(query_580334, "prettyPrint", newJBool(prettyPrint))
  add(query_580334, "oauth_token", newJString(oauthToken))
  add(query_580334, "$.xgafv", newJString(Xgafv))
  add(query_580334, "alt", newJString(alt))
  add(query_580334, "uploadType", newJString(uploadType))
  add(query_580334, "quotaUser", newJString(quotaUser))
  add(path_580333, "location", newJString(location))
  if body != nil:
    body_580335 = body
  add(query_580334, "callback", newJString(callback))
  add(path_580333, "parent", newJString(parent))
  add(query_580334, "fields", newJString(fields))
  add(query_580334, "access_token", newJString(accessToken))
  add(query_580334, "upload_protocol", newJString(uploadProtocol))
  result = call_580332.call(path_580333, query_580334, nil, nil, body_580335)

var dlpProjectsLocationsContentDeidentify* = Call_DlpProjectsLocationsContentDeidentify_580314(
    name: "dlpProjectsLocationsContentDeidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com",
    route: "/v2/{parent}/locations/{location}/content:deidentify",
    validator: validate_DlpProjectsLocationsContentDeidentify_580315, base: "/",
    url: url_DlpProjectsLocationsContentDeidentify_580316, schemes: {Scheme.Https})
type
  Call_DlpProjectsLocationsContentInspect_580336 = ref object of OpenApiRestCall_579373
proc url_DlpProjectsLocationsContentInspect_580338(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/content:inspect")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpProjectsLocationsContentInspect_580337(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  ## For how to guides, see https://cloud.google.com/dlp/docs/inspecting-images
  ## and https://cloud.google.com/dlp/docs/inspecting-text,
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   location: JString (required)
  ##           : The geographic location to process content inspection. Reserved for future
  ## extensions.
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `location` field"
  var valid_580339 = path.getOrDefault("location")
  valid_580339 = validateParameter(valid_580339, JString, required = true,
                                 default = nil)
  if valid_580339 != nil:
    section.add "location", valid_580339
  var valid_580340 = path.getOrDefault("parent")
  valid_580340 = validateParameter(valid_580340, JString, required = true,
                                 default = nil)
  if valid_580340 != nil:
    section.add "parent", valid_580340
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
  var valid_580341 = query.getOrDefault("key")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "key", valid_580341
  var valid_580342 = query.getOrDefault("prettyPrint")
  valid_580342 = validateParameter(valid_580342, JBool, required = false,
                                 default = newJBool(true))
  if valid_580342 != nil:
    section.add "prettyPrint", valid_580342
  var valid_580343 = query.getOrDefault("oauth_token")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "oauth_token", valid_580343
  var valid_580344 = query.getOrDefault("$.xgafv")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = newJString("1"))
  if valid_580344 != nil:
    section.add "$.xgafv", valid_580344
  var valid_580345 = query.getOrDefault("alt")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = newJString("json"))
  if valid_580345 != nil:
    section.add "alt", valid_580345
  var valid_580346 = query.getOrDefault("uploadType")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "uploadType", valid_580346
  var valid_580347 = query.getOrDefault("quotaUser")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "quotaUser", valid_580347
  var valid_580348 = query.getOrDefault("callback")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "callback", valid_580348
  var valid_580349 = query.getOrDefault("fields")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "fields", valid_580349
  var valid_580350 = query.getOrDefault("access_token")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "access_token", valid_580350
  var valid_580351 = query.getOrDefault("upload_protocol")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "upload_protocol", valid_580351
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

proc call*(call_580353: Call_DlpProjectsLocationsContentInspect_580336;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  ## For how to guides, see https://cloud.google.com/dlp/docs/inspecting-images
  ## and https://cloud.google.com/dlp/docs/inspecting-text,
  ## 
  let valid = call_580353.validator(path, query, header, formData, body)
  let scheme = call_580353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580353.url(scheme.get, call_580353.host, call_580353.base,
                         call_580353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580353, url, valid)

proc call*(call_580354: Call_DlpProjectsLocationsContentInspect_580336;
          location: string; parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpProjectsLocationsContentInspect
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  ## For how to guides, see https://cloud.google.com/dlp/docs/inspecting-images
  ## and https://cloud.google.com/dlp/docs/inspecting-text,
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
  ##   location: string (required)
  ##           : The geographic location to process content inspection. Reserved for future
  ## extensions.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580355 = newJObject()
  var query_580356 = newJObject()
  var body_580357 = newJObject()
  add(query_580356, "key", newJString(key))
  add(query_580356, "prettyPrint", newJBool(prettyPrint))
  add(query_580356, "oauth_token", newJString(oauthToken))
  add(query_580356, "$.xgafv", newJString(Xgafv))
  add(query_580356, "alt", newJString(alt))
  add(query_580356, "uploadType", newJString(uploadType))
  add(query_580356, "quotaUser", newJString(quotaUser))
  add(path_580355, "location", newJString(location))
  if body != nil:
    body_580357 = body
  add(query_580356, "callback", newJString(callback))
  add(path_580355, "parent", newJString(parent))
  add(query_580356, "fields", newJString(fields))
  add(query_580356, "access_token", newJString(accessToken))
  add(query_580356, "upload_protocol", newJString(uploadProtocol))
  result = call_580354.call(path_580355, query_580356, nil, nil, body_580357)

var dlpProjectsLocationsContentInspect* = Call_DlpProjectsLocationsContentInspect_580336(
    name: "dlpProjectsLocationsContentInspect", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com",
    route: "/v2/{parent}/locations/{location}/content:inspect",
    validator: validate_DlpProjectsLocationsContentInspect_580337, base: "/",
    url: url_DlpProjectsLocationsContentInspect_580338, schemes: {Scheme.Https})
type
  Call_DlpProjectsLocationsContentReidentify_580358 = ref object of OpenApiRestCall_579373
proc url_DlpProjectsLocationsContentReidentify_580360(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/content:reidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpProjectsLocationsContentReidentify_580359(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   location: JString (required)
  ##           : The geographic location to process content reidentification.  Reserved for
  ## future extensions.
  ##   parent: JString (required)
  ##         : Required. The parent resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `location` field"
  var valid_580361 = path.getOrDefault("location")
  valid_580361 = validateParameter(valid_580361, JString, required = true,
                                 default = nil)
  if valid_580361 != nil:
    section.add "location", valid_580361
  var valid_580362 = path.getOrDefault("parent")
  valid_580362 = validateParameter(valid_580362, JString, required = true,
                                 default = nil)
  if valid_580362 != nil:
    section.add "parent", valid_580362
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
  var valid_580363 = query.getOrDefault("key")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "key", valid_580363
  var valid_580364 = query.getOrDefault("prettyPrint")
  valid_580364 = validateParameter(valid_580364, JBool, required = false,
                                 default = newJBool(true))
  if valid_580364 != nil:
    section.add "prettyPrint", valid_580364
  var valid_580365 = query.getOrDefault("oauth_token")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "oauth_token", valid_580365
  var valid_580366 = query.getOrDefault("$.xgafv")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = newJString("1"))
  if valid_580366 != nil:
    section.add "$.xgafv", valid_580366
  var valid_580367 = query.getOrDefault("alt")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = newJString("json"))
  if valid_580367 != nil:
    section.add "alt", valid_580367
  var valid_580368 = query.getOrDefault("uploadType")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "uploadType", valid_580368
  var valid_580369 = query.getOrDefault("quotaUser")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "quotaUser", valid_580369
  var valid_580370 = query.getOrDefault("callback")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "callback", valid_580370
  var valid_580371 = query.getOrDefault("fields")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "fields", valid_580371
  var valid_580372 = query.getOrDefault("access_token")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "access_token", valid_580372
  var valid_580373 = query.getOrDefault("upload_protocol")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "upload_protocol", valid_580373
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

proc call*(call_580375: Call_DlpProjectsLocationsContentReidentify_580358;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
  ## 
  let valid = call_580375.validator(path, query, header, formData, body)
  let scheme = call_580375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580375.url(scheme.get, call_580375.host, call_580375.base,
                         call_580375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580375, url, valid)

proc call*(call_580376: Call_DlpProjectsLocationsContentReidentify_580358;
          location: string; parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpProjectsLocationsContentReidentify
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
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
  ##   location: string (required)
  ##           : The geographic location to process content reidentification.  Reserved for
  ## future extensions.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The parent resource name.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580377 = newJObject()
  var query_580378 = newJObject()
  var body_580379 = newJObject()
  add(query_580378, "key", newJString(key))
  add(query_580378, "prettyPrint", newJBool(prettyPrint))
  add(query_580378, "oauth_token", newJString(oauthToken))
  add(query_580378, "$.xgafv", newJString(Xgafv))
  add(query_580378, "alt", newJString(alt))
  add(query_580378, "uploadType", newJString(uploadType))
  add(query_580378, "quotaUser", newJString(quotaUser))
  add(path_580377, "location", newJString(location))
  if body != nil:
    body_580379 = body
  add(query_580378, "callback", newJString(callback))
  add(path_580377, "parent", newJString(parent))
  add(query_580378, "fields", newJString(fields))
  add(query_580378, "access_token", newJString(accessToken))
  add(query_580378, "upload_protocol", newJString(uploadProtocol))
  result = call_580376.call(path_580377, query_580378, nil, nil, body_580379)

var dlpProjectsLocationsContentReidentify* = Call_DlpProjectsLocationsContentReidentify_580358(
    name: "dlpProjectsLocationsContentReidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com",
    route: "/v2/{parent}/locations/{location}/content:reidentify",
    validator: validate_DlpProjectsLocationsContentReidentify_580359, base: "/",
    url: url_DlpProjectsLocationsContentReidentify_580360, schemes: {Scheme.Https})
type
  Call_DlpProjectsLocationsImageRedact_580380 = ref object of OpenApiRestCall_579373
proc url_DlpProjectsLocationsImageRedact_580382(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/image:redact")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpProjectsLocationsImageRedact_580381(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## See https://cloud.google.com/dlp/docs/redacting-sensitive-data-images to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   location: JString (required)
  ##           : The geographic location to process the request. Reserved for future
  ## extensions.
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `location` field"
  var valid_580383 = path.getOrDefault("location")
  valid_580383 = validateParameter(valid_580383, JString, required = true,
                                 default = nil)
  if valid_580383 != nil:
    section.add "location", valid_580383
  var valid_580384 = path.getOrDefault("parent")
  valid_580384 = validateParameter(valid_580384, JString, required = true,
                                 default = nil)
  if valid_580384 != nil:
    section.add "parent", valid_580384
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
  var valid_580385 = query.getOrDefault("key")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "key", valid_580385
  var valid_580386 = query.getOrDefault("prettyPrint")
  valid_580386 = validateParameter(valid_580386, JBool, required = false,
                                 default = newJBool(true))
  if valid_580386 != nil:
    section.add "prettyPrint", valid_580386
  var valid_580387 = query.getOrDefault("oauth_token")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "oauth_token", valid_580387
  var valid_580388 = query.getOrDefault("$.xgafv")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = newJString("1"))
  if valid_580388 != nil:
    section.add "$.xgafv", valid_580388
  var valid_580389 = query.getOrDefault("alt")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = newJString("json"))
  if valid_580389 != nil:
    section.add "alt", valid_580389
  var valid_580390 = query.getOrDefault("uploadType")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "uploadType", valid_580390
  var valid_580391 = query.getOrDefault("quotaUser")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "quotaUser", valid_580391
  var valid_580392 = query.getOrDefault("callback")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "callback", valid_580392
  var valid_580393 = query.getOrDefault("fields")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "fields", valid_580393
  var valid_580394 = query.getOrDefault("access_token")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "access_token", valid_580394
  var valid_580395 = query.getOrDefault("upload_protocol")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "upload_protocol", valid_580395
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

proc call*(call_580397: Call_DlpProjectsLocationsImageRedact_580380;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## See https://cloud.google.com/dlp/docs/redacting-sensitive-data-images to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  let valid = call_580397.validator(path, query, header, formData, body)
  let scheme = call_580397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580397.url(scheme.get, call_580397.host, call_580397.base,
                         call_580397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580397, url, valid)

proc call*(call_580398: Call_DlpProjectsLocationsImageRedact_580380;
          location: string; parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpProjectsLocationsImageRedact
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## See https://cloud.google.com/dlp/docs/redacting-sensitive-data-images to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
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
  ##   location: string (required)
  ##           : The geographic location to process the request. Reserved for future
  ## extensions.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580399 = newJObject()
  var query_580400 = newJObject()
  var body_580401 = newJObject()
  add(query_580400, "key", newJString(key))
  add(query_580400, "prettyPrint", newJBool(prettyPrint))
  add(query_580400, "oauth_token", newJString(oauthToken))
  add(query_580400, "$.xgafv", newJString(Xgafv))
  add(query_580400, "alt", newJString(alt))
  add(query_580400, "uploadType", newJString(uploadType))
  add(query_580400, "quotaUser", newJString(quotaUser))
  add(path_580399, "location", newJString(location))
  if body != nil:
    body_580401 = body
  add(query_580400, "callback", newJString(callback))
  add(path_580399, "parent", newJString(parent))
  add(query_580400, "fields", newJString(fields))
  add(query_580400, "access_token", newJString(accessToken))
  add(query_580400, "upload_protocol", newJString(uploadProtocol))
  result = call_580398.call(path_580399, query_580400, nil, nil, body_580401)

var dlpProjectsLocationsImageRedact* = Call_DlpProjectsLocationsImageRedact_580380(
    name: "dlpProjectsLocationsImageRedact", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com",
    route: "/v2/{parent}/locations/{location}/image:redact",
    validator: validate_DlpProjectsLocationsImageRedact_580381, base: "/",
    url: url_DlpProjectsLocationsImageRedact_580382, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsStoredInfoTypesCreate_580424 = ref object of OpenApiRestCall_579373
proc url_DlpOrganizationsStoredInfoTypesCreate_580426(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/storedInfoTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpOrganizationsStoredInfoTypesCreate_580425(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a pre-built stored infoType to be used for inspection.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580427 = path.getOrDefault("parent")
  valid_580427 = validateParameter(valid_580427, JString, required = true,
                                 default = nil)
  if valid_580427 != nil:
    section.add "parent", valid_580427
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
  var valid_580428 = query.getOrDefault("key")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "key", valid_580428
  var valid_580429 = query.getOrDefault("prettyPrint")
  valid_580429 = validateParameter(valid_580429, JBool, required = false,
                                 default = newJBool(true))
  if valid_580429 != nil:
    section.add "prettyPrint", valid_580429
  var valid_580430 = query.getOrDefault("oauth_token")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "oauth_token", valid_580430
  var valid_580431 = query.getOrDefault("$.xgafv")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = newJString("1"))
  if valid_580431 != nil:
    section.add "$.xgafv", valid_580431
  var valid_580432 = query.getOrDefault("alt")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = newJString("json"))
  if valid_580432 != nil:
    section.add "alt", valid_580432
  var valid_580433 = query.getOrDefault("uploadType")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "uploadType", valid_580433
  var valid_580434 = query.getOrDefault("quotaUser")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "quotaUser", valid_580434
  var valid_580435 = query.getOrDefault("callback")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "callback", valid_580435
  var valid_580436 = query.getOrDefault("fields")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "fields", valid_580436
  var valid_580437 = query.getOrDefault("access_token")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "access_token", valid_580437
  var valid_580438 = query.getOrDefault("upload_protocol")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "upload_protocol", valid_580438
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

proc call*(call_580440: Call_DlpOrganizationsStoredInfoTypesCreate_580424;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a pre-built stored infoType to be used for inspection.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  let valid = call_580440.validator(path, query, header, formData, body)
  let scheme = call_580440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580440.url(scheme.get, call_580440.host, call_580440.base,
                         call_580440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580440, url, valid)

proc call*(call_580441: Call_DlpOrganizationsStoredInfoTypesCreate_580424;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dlpOrganizationsStoredInfoTypesCreate
  ## Creates a pre-built stored infoType to be used for inspection.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
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
  ##   parent: string (required)
  ##         : Required. The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580442 = newJObject()
  var query_580443 = newJObject()
  var body_580444 = newJObject()
  add(query_580443, "key", newJString(key))
  add(query_580443, "prettyPrint", newJBool(prettyPrint))
  add(query_580443, "oauth_token", newJString(oauthToken))
  add(query_580443, "$.xgafv", newJString(Xgafv))
  add(query_580443, "alt", newJString(alt))
  add(query_580443, "uploadType", newJString(uploadType))
  add(query_580443, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580444 = body
  add(query_580443, "callback", newJString(callback))
  add(path_580442, "parent", newJString(parent))
  add(query_580443, "fields", newJString(fields))
  add(query_580443, "access_token", newJString(accessToken))
  add(query_580443, "upload_protocol", newJString(uploadProtocol))
  result = call_580441.call(path_580442, query_580443, nil, nil, body_580444)

var dlpOrganizationsStoredInfoTypesCreate* = Call_DlpOrganizationsStoredInfoTypesCreate_580424(
    name: "dlpOrganizationsStoredInfoTypesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/storedInfoTypes",
    validator: validate_DlpOrganizationsStoredInfoTypesCreate_580425, base: "/",
    url: url_DlpOrganizationsStoredInfoTypesCreate_580426, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsStoredInfoTypesList_580402 = ref object of OpenApiRestCall_579373
proc url_DlpOrganizationsStoredInfoTypesList_580404(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/storedInfoTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DlpOrganizationsStoredInfoTypesList_580403(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists stored infoTypes.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580405 = path.getOrDefault("parent")
  valid_580405 = validateParameter(valid_580405, JString, required = true,
                                 default = nil)
  if valid_580405 != nil:
    section.add "parent", valid_580405
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
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc, display_name, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the most recent version of the
  ## resource was created.
  ## - `state`: corresponds to the state of the resource.
  ## - `name`: corresponds to resource name.
  ## - `display_name`: corresponds to info type's display name.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListStoredInfoTypes`.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580406 = query.getOrDefault("key")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "key", valid_580406
  var valid_580407 = query.getOrDefault("prettyPrint")
  valid_580407 = validateParameter(valid_580407, JBool, required = false,
                                 default = newJBool(true))
  if valid_580407 != nil:
    section.add "prettyPrint", valid_580407
  var valid_580408 = query.getOrDefault("oauth_token")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "oauth_token", valid_580408
  var valid_580409 = query.getOrDefault("$.xgafv")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = newJString("1"))
  if valid_580409 != nil:
    section.add "$.xgafv", valid_580409
  var valid_580410 = query.getOrDefault("pageSize")
  valid_580410 = validateParameter(valid_580410, JInt, required = false, default = nil)
  if valid_580410 != nil:
    section.add "pageSize", valid_580410
  var valid_580411 = query.getOrDefault("alt")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = newJString("json"))
  if valid_580411 != nil:
    section.add "alt", valid_580411
  var valid_580412 = query.getOrDefault("uploadType")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "uploadType", valid_580412
  var valid_580413 = query.getOrDefault("quotaUser")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "quotaUser", valid_580413
  var valid_580414 = query.getOrDefault("orderBy")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "orderBy", valid_580414
  var valid_580415 = query.getOrDefault("pageToken")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "pageToken", valid_580415
  var valid_580416 = query.getOrDefault("callback")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "callback", valid_580416
  var valid_580417 = query.getOrDefault("fields")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "fields", valid_580417
  var valid_580418 = query.getOrDefault("access_token")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "access_token", valid_580418
  var valid_580419 = query.getOrDefault("upload_protocol")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "upload_protocol", valid_580419
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580420: Call_DlpOrganizationsStoredInfoTypesList_580402;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists stored infoTypes.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  let valid = call_580420.validator(path, query, header, formData, body)
  let scheme = call_580420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580420.url(scheme.get, call_580420.host, call_580420.base,
                         call_580420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580420, url, valid)

proc call*(call_580421: Call_DlpOrganizationsStoredInfoTypesList_580402;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          orderBy: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dlpOrganizationsStoredInfoTypesList
  ## Lists stored infoTypes.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Optional comma separated list of fields to order by,
  ## followed by `asc` or `desc` postfix. This list is case-insensitive,
  ## default sorting order is ascending, redundant space characters are
  ## insignificant.
  ## 
  ## Example: `name asc, display_name, create_time desc`
  ## 
  ## Supported fields are:
  ## 
  ## - `create_time`: corresponds to time the most recent version of the
  ## resource was created.
  ## - `state`: corresponds to the state of the resource.
  ## - `name`: corresponds to resource name.
  ## - `display_name`: corresponds to info type's display name.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListStoredInfoTypes`.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580422 = newJObject()
  var query_580423 = newJObject()
  add(query_580423, "key", newJString(key))
  add(query_580423, "prettyPrint", newJBool(prettyPrint))
  add(query_580423, "oauth_token", newJString(oauthToken))
  add(query_580423, "$.xgafv", newJString(Xgafv))
  add(query_580423, "pageSize", newJInt(pageSize))
  add(query_580423, "alt", newJString(alt))
  add(query_580423, "uploadType", newJString(uploadType))
  add(query_580423, "quotaUser", newJString(quotaUser))
  add(query_580423, "orderBy", newJString(orderBy))
  add(query_580423, "pageToken", newJString(pageToken))
  add(query_580423, "callback", newJString(callback))
  add(path_580422, "parent", newJString(parent))
  add(query_580423, "fields", newJString(fields))
  add(query_580423, "access_token", newJString(accessToken))
  add(query_580423, "upload_protocol", newJString(uploadProtocol))
  result = call_580421.call(path_580422, query_580423, nil, nil, nil)

var dlpOrganizationsStoredInfoTypesList* = Call_DlpOrganizationsStoredInfoTypesList_580402(
    name: "dlpOrganizationsStoredInfoTypesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/storedInfoTypes",
    validator: validate_DlpOrganizationsStoredInfoTypesList_580403, base: "/",
    url: url_DlpOrganizationsStoredInfoTypesList_580404, schemes: {Scheme.Https})
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
