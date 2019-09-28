
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  gcpServiceName = "dlp"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DlpInfoTypesList_579690 = ref object of OpenApiRestCall_579421
proc url_DlpInfoTypesList_579692(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DlpInfoTypesList_579691(path: JsonNode; query: JsonNode;
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
  ##   location: JString
  ##           : The geographic location to list info types. Reserved for future
  ## extensions.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   languageCode: JString
  ##               : Optional BCP-47 language code for localized infoType friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional filter to only return infoTypes supported by certain parts of the
  ## API. Defaults to supported_by=INSPECT.
  section = newJObject()
  var valid_579804 = query.getOrDefault("upload_protocol")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "upload_protocol", valid_579804
  var valid_579805 = query.getOrDefault("fields")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "fields", valid_579805
  var valid_579806 = query.getOrDefault("quotaUser")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "quotaUser", valid_579806
  var valid_579820 = query.getOrDefault("alt")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = newJString("json"))
  if valid_579820 != nil:
    section.add "alt", valid_579820
  var valid_579821 = query.getOrDefault("oauth_token")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "oauth_token", valid_579821
  var valid_579822 = query.getOrDefault("callback")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "callback", valid_579822
  var valid_579823 = query.getOrDefault("access_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "access_token", valid_579823
  var valid_579824 = query.getOrDefault("uploadType")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "uploadType", valid_579824
  var valid_579825 = query.getOrDefault("location")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "location", valid_579825
  var valid_579826 = query.getOrDefault("key")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "key", valid_579826
  var valid_579827 = query.getOrDefault("$.xgafv")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = newJString("1"))
  if valid_579827 != nil:
    section.add "$.xgafv", valid_579827
  var valid_579828 = query.getOrDefault("languageCode")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "languageCode", valid_579828
  var valid_579829 = query.getOrDefault("prettyPrint")
  valid_579829 = validateParameter(valid_579829, JBool, required = false,
                                 default = newJBool(true))
  if valid_579829 != nil:
    section.add "prettyPrint", valid_579829
  var valid_579830 = query.getOrDefault("filter")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = nil)
  if valid_579830 != nil:
    section.add "filter", valid_579830
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579853: Call_DlpInfoTypesList_579690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
  ## 
  let valid = call_579853.validator(path, query, header, formData, body)
  let scheme = call_579853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579853.url(scheme.get, call_579853.host, call_579853.base,
                         call_579853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579853, url, valid)

proc call*(call_579924: Call_DlpInfoTypesList_579690; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; location: string = ""; key: string = "";
          Xgafv: string = "1"; languageCode: string = ""; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## dlpInfoTypesList
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
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
  ##   location: string
  ##           : The geographic location to list info types. Reserved for future
  ## extensions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   languageCode: string
  ##               : Optional BCP-47 language code for localized infoType friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional filter to only return infoTypes supported by certain parts of the
  ## API. Defaults to supported_by=INSPECT.
  var query_579925 = newJObject()
  add(query_579925, "upload_protocol", newJString(uploadProtocol))
  add(query_579925, "fields", newJString(fields))
  add(query_579925, "quotaUser", newJString(quotaUser))
  add(query_579925, "alt", newJString(alt))
  add(query_579925, "oauth_token", newJString(oauthToken))
  add(query_579925, "callback", newJString(callback))
  add(query_579925, "access_token", newJString(accessToken))
  add(query_579925, "uploadType", newJString(uploadType))
  add(query_579925, "location", newJString(location))
  add(query_579925, "key", newJString(key))
  add(query_579925, "$.xgafv", newJString(Xgafv))
  add(query_579925, "languageCode", newJString(languageCode))
  add(query_579925, "prettyPrint", newJBool(prettyPrint))
  add(query_579925, "filter", newJString(filter))
  result = call_579924.call(nil, query_579925, nil, nil, nil)

var dlpInfoTypesList* = Call_DlpInfoTypesList_579690(name: "dlpInfoTypesList",
    meth: HttpMethod.HttpGet, host: "dlp.googleapis.com", route: "/v2/infoTypes",
    validator: validate_DlpInfoTypesList_579691, base: "/",
    url: url_DlpInfoTypesList_579692, schemes: {Scheme.Https})
type
  Call_DlpLocationsInfoTypes_579965 = ref object of OpenApiRestCall_579421
proc url_DlpLocationsInfoTypes_579967(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
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
  result.path = base & hydrated.get

proc validate_DlpLocationsInfoTypes_579966(path: JsonNode; query: JsonNode;
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
  var valid_579982 = path.getOrDefault("location")
  valid_579982 = validateParameter(valid_579982, JString, required = true,
                                 default = nil)
  if valid_579982 != nil:
    section.add "location", valid_579982
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
  var valid_579983 = query.getOrDefault("upload_protocol")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "upload_protocol", valid_579983
  var valid_579984 = query.getOrDefault("fields")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "fields", valid_579984
  var valid_579985 = query.getOrDefault("quotaUser")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "quotaUser", valid_579985
  var valid_579986 = query.getOrDefault("alt")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = newJString("json"))
  if valid_579986 != nil:
    section.add "alt", valid_579986
  var valid_579987 = query.getOrDefault("oauth_token")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "oauth_token", valid_579987
  var valid_579988 = query.getOrDefault("callback")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "callback", valid_579988
  var valid_579989 = query.getOrDefault("access_token")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "access_token", valid_579989
  var valid_579990 = query.getOrDefault("uploadType")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "uploadType", valid_579990
  var valid_579991 = query.getOrDefault("key")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "key", valid_579991
  var valid_579992 = query.getOrDefault("$.xgafv")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = newJString("1"))
  if valid_579992 != nil:
    section.add "$.xgafv", valid_579992
  var valid_579993 = query.getOrDefault("prettyPrint")
  valid_579993 = validateParameter(valid_579993, JBool, required = false,
                                 default = newJBool(true))
  if valid_579993 != nil:
    section.add "prettyPrint", valid_579993
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

proc call*(call_579995: Call_DlpLocationsInfoTypes_579965; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
  ## 
  let valid = call_579995.validator(path, query, header, formData, body)
  let scheme = call_579995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579995.url(scheme.get, call_579995.host, call_579995.base,
                         call_579995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579995, url, valid)

proc call*(call_579996: Call_DlpLocationsInfoTypes_579965; location: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpLocationsInfoTypes
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
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
  ##   location: string (required)
  ##           : The geographic location to list info types. Reserved for future
  ## extensions.
  var path_579997 = newJObject()
  var query_579998 = newJObject()
  var body_579999 = newJObject()
  add(query_579998, "upload_protocol", newJString(uploadProtocol))
  add(query_579998, "fields", newJString(fields))
  add(query_579998, "quotaUser", newJString(quotaUser))
  add(query_579998, "alt", newJString(alt))
  add(query_579998, "oauth_token", newJString(oauthToken))
  add(query_579998, "callback", newJString(callback))
  add(query_579998, "access_token", newJString(accessToken))
  add(query_579998, "uploadType", newJString(uploadType))
  add(query_579998, "key", newJString(key))
  add(query_579998, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579999 = body
  add(query_579998, "prettyPrint", newJBool(prettyPrint))
  add(path_579997, "location", newJString(location))
  result = call_579996.call(path_579997, query_579998, nil, nil, body_579999)

var dlpLocationsInfoTypes* = Call_DlpLocationsInfoTypes_579965(
    name: "dlpLocationsInfoTypes", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/locations/{location}/infoTypes",
    validator: validate_DlpLocationsInfoTypes_579966, base: "/",
    url: url_DlpLocationsInfoTypes_579967, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsStoredInfoTypesGet_580000 = ref object of OpenApiRestCall_579421
proc url_DlpOrganizationsStoredInfoTypesGet_580002(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DlpOrganizationsStoredInfoTypesGet_580001(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a stored infoType.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the organization and storedInfoType to be read, for
  ## example `organizations/433245324/storedInfoTypes/432452342` or
  ## projects/project-id/storedInfoTypes/432452342.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580003 = path.getOrDefault("name")
  valid_580003 = validateParameter(valid_580003, JString, required = true,
                                 default = nil)
  if valid_580003 != nil:
    section.add "name", valid_580003
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
  var valid_580004 = query.getOrDefault("upload_protocol")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "upload_protocol", valid_580004
  var valid_580005 = query.getOrDefault("fields")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "fields", valid_580005
  var valid_580006 = query.getOrDefault("quotaUser")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "quotaUser", valid_580006
  var valid_580007 = query.getOrDefault("alt")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = newJString("json"))
  if valid_580007 != nil:
    section.add "alt", valid_580007
  var valid_580008 = query.getOrDefault("oauth_token")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "oauth_token", valid_580008
  var valid_580009 = query.getOrDefault("callback")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "callback", valid_580009
  var valid_580010 = query.getOrDefault("access_token")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "access_token", valid_580010
  var valid_580011 = query.getOrDefault("uploadType")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "uploadType", valid_580011
  var valid_580012 = query.getOrDefault("key")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "key", valid_580012
  var valid_580013 = query.getOrDefault("$.xgafv")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = newJString("1"))
  if valid_580013 != nil:
    section.add "$.xgafv", valid_580013
  var valid_580014 = query.getOrDefault("prettyPrint")
  valid_580014 = validateParameter(valid_580014, JBool, required = false,
                                 default = newJBool(true))
  if valid_580014 != nil:
    section.add "prettyPrint", valid_580014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580015: Call_DlpOrganizationsStoredInfoTypesGet_580000;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a stored infoType.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  let valid = call_580015.validator(path, query, header, formData, body)
  let scheme = call_580015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580015.url(scheme.get, call_580015.host, call_580015.base,
                         call_580015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580015, url, valid)

proc call*(call_580016: Call_DlpOrganizationsStoredInfoTypesGet_580000;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## dlpOrganizationsStoredInfoTypesGet
  ## Gets a stored infoType.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the organization and storedInfoType to be read, for
  ## example `organizations/433245324/storedInfoTypes/432452342` or
  ## projects/project-id/storedInfoTypes/432452342.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580017 = newJObject()
  var query_580018 = newJObject()
  add(query_580018, "upload_protocol", newJString(uploadProtocol))
  add(query_580018, "fields", newJString(fields))
  add(query_580018, "quotaUser", newJString(quotaUser))
  add(path_580017, "name", newJString(name))
  add(query_580018, "alt", newJString(alt))
  add(query_580018, "oauth_token", newJString(oauthToken))
  add(query_580018, "callback", newJString(callback))
  add(query_580018, "access_token", newJString(accessToken))
  add(query_580018, "uploadType", newJString(uploadType))
  add(query_580018, "key", newJString(key))
  add(query_580018, "$.xgafv", newJString(Xgafv))
  add(query_580018, "prettyPrint", newJBool(prettyPrint))
  result = call_580016.call(path_580017, query_580018, nil, nil, nil)

var dlpOrganizationsStoredInfoTypesGet* = Call_DlpOrganizationsStoredInfoTypesGet_580000(
    name: "dlpOrganizationsStoredInfoTypesGet", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{name}",
    validator: validate_DlpOrganizationsStoredInfoTypesGet_580001, base: "/",
    url: url_DlpOrganizationsStoredInfoTypesGet_580002, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsStoredInfoTypesPatch_580038 = ref object of OpenApiRestCall_579421
proc url_DlpOrganizationsStoredInfoTypesPatch_580040(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_DlpOrganizationsStoredInfoTypesPatch_580039(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the stored infoType by creating a new version. The existing version
  ## will continue to be used until the new version is ready.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of organization and storedInfoType to be updated, for
  ## example `organizations/433245324/storedInfoTypes/432452342` or
  ## projects/project-id/storedInfoTypes/432452342.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580041 = path.getOrDefault("name")
  valid_580041 = validateParameter(valid_580041, JString, required = true,
                                 default = nil)
  if valid_580041 != nil:
    section.add "name", valid_580041
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
  var valid_580042 = query.getOrDefault("upload_protocol")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "upload_protocol", valid_580042
  var valid_580043 = query.getOrDefault("fields")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "fields", valid_580043
  var valid_580044 = query.getOrDefault("quotaUser")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "quotaUser", valid_580044
  var valid_580045 = query.getOrDefault("alt")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = newJString("json"))
  if valid_580045 != nil:
    section.add "alt", valid_580045
  var valid_580046 = query.getOrDefault("oauth_token")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "oauth_token", valid_580046
  var valid_580047 = query.getOrDefault("callback")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "callback", valid_580047
  var valid_580048 = query.getOrDefault("access_token")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "access_token", valid_580048
  var valid_580049 = query.getOrDefault("uploadType")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "uploadType", valid_580049
  var valid_580050 = query.getOrDefault("key")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "key", valid_580050
  var valid_580051 = query.getOrDefault("$.xgafv")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = newJString("1"))
  if valid_580051 != nil:
    section.add "$.xgafv", valid_580051
  var valid_580052 = query.getOrDefault("prettyPrint")
  valid_580052 = validateParameter(valid_580052, JBool, required = false,
                                 default = newJBool(true))
  if valid_580052 != nil:
    section.add "prettyPrint", valid_580052
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

proc call*(call_580054: Call_DlpOrganizationsStoredInfoTypesPatch_580038;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the stored infoType by creating a new version. The existing version
  ## will continue to be used until the new version is ready.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  let valid = call_580054.validator(path, query, header, formData, body)
  let scheme = call_580054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580054.url(scheme.get, call_580054.host, call_580054.base,
                         call_580054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580054, url, valid)

proc call*(call_580055: Call_DlpOrganizationsStoredInfoTypesPatch_580038;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dlpOrganizationsStoredInfoTypesPatch
  ## Updates the stored infoType by creating a new version. The existing version
  ## will continue to be used until the new version is ready.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of organization and storedInfoType to be updated, for
  ## example `organizations/433245324/storedInfoTypes/432452342` or
  ## projects/project-id/storedInfoTypes/432452342.
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
  var path_580056 = newJObject()
  var query_580057 = newJObject()
  var body_580058 = newJObject()
  add(query_580057, "upload_protocol", newJString(uploadProtocol))
  add(query_580057, "fields", newJString(fields))
  add(query_580057, "quotaUser", newJString(quotaUser))
  add(path_580056, "name", newJString(name))
  add(query_580057, "alt", newJString(alt))
  add(query_580057, "oauth_token", newJString(oauthToken))
  add(query_580057, "callback", newJString(callback))
  add(query_580057, "access_token", newJString(accessToken))
  add(query_580057, "uploadType", newJString(uploadType))
  add(query_580057, "key", newJString(key))
  add(query_580057, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580058 = body
  add(query_580057, "prettyPrint", newJBool(prettyPrint))
  result = call_580055.call(path_580056, query_580057, nil, nil, body_580058)

var dlpOrganizationsStoredInfoTypesPatch* = Call_DlpOrganizationsStoredInfoTypesPatch_580038(
    name: "dlpOrganizationsStoredInfoTypesPatch", meth: HttpMethod.HttpPatch,
    host: "dlp.googleapis.com", route: "/v2/{name}",
    validator: validate_DlpOrganizationsStoredInfoTypesPatch_580039, base: "/",
    url: url_DlpOrganizationsStoredInfoTypesPatch_580040, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsStoredInfoTypesDelete_580019 = ref object of OpenApiRestCall_579421
proc url_DlpOrganizationsStoredInfoTypesDelete_580021(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_DlpOrganizationsStoredInfoTypesDelete_580020(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a stored infoType.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the organization and storedInfoType to be deleted, for
  ## example `organizations/433245324/storedInfoTypes/432452342` or
  ## projects/project-id/storedInfoTypes/432452342.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580022 = path.getOrDefault("name")
  valid_580022 = validateParameter(valid_580022, JString, required = true,
                                 default = nil)
  if valid_580022 != nil:
    section.add "name", valid_580022
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
  var valid_580023 = query.getOrDefault("upload_protocol")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "upload_protocol", valid_580023
  var valid_580024 = query.getOrDefault("fields")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "fields", valid_580024
  var valid_580025 = query.getOrDefault("quotaUser")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "quotaUser", valid_580025
  var valid_580026 = query.getOrDefault("alt")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = newJString("json"))
  if valid_580026 != nil:
    section.add "alt", valid_580026
  var valid_580027 = query.getOrDefault("oauth_token")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "oauth_token", valid_580027
  var valid_580028 = query.getOrDefault("callback")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "callback", valid_580028
  var valid_580029 = query.getOrDefault("access_token")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "access_token", valid_580029
  var valid_580030 = query.getOrDefault("uploadType")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "uploadType", valid_580030
  var valid_580031 = query.getOrDefault("key")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "key", valid_580031
  var valid_580032 = query.getOrDefault("$.xgafv")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = newJString("1"))
  if valid_580032 != nil:
    section.add "$.xgafv", valid_580032
  var valid_580033 = query.getOrDefault("prettyPrint")
  valid_580033 = validateParameter(valid_580033, JBool, required = false,
                                 default = newJBool(true))
  if valid_580033 != nil:
    section.add "prettyPrint", valid_580033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580034: Call_DlpOrganizationsStoredInfoTypesDelete_580019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a stored infoType.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  let valid = call_580034.validator(path, query, header, formData, body)
  let scheme = call_580034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580034.url(scheme.get, call_580034.host, call_580034.base,
                         call_580034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580034, url, valid)

proc call*(call_580035: Call_DlpOrganizationsStoredInfoTypesDelete_580019;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## dlpOrganizationsStoredInfoTypesDelete
  ## Deletes a stored infoType.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the organization and storedInfoType to be deleted, for
  ## example `organizations/433245324/storedInfoTypes/432452342` or
  ## projects/project-id/storedInfoTypes/432452342.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580036 = newJObject()
  var query_580037 = newJObject()
  add(query_580037, "upload_protocol", newJString(uploadProtocol))
  add(query_580037, "fields", newJString(fields))
  add(query_580037, "quotaUser", newJString(quotaUser))
  add(path_580036, "name", newJString(name))
  add(query_580037, "alt", newJString(alt))
  add(query_580037, "oauth_token", newJString(oauthToken))
  add(query_580037, "callback", newJString(callback))
  add(query_580037, "access_token", newJString(accessToken))
  add(query_580037, "uploadType", newJString(uploadType))
  add(query_580037, "key", newJString(key))
  add(query_580037, "$.xgafv", newJString(Xgafv))
  add(query_580037, "prettyPrint", newJBool(prettyPrint))
  result = call_580035.call(path_580036, query_580037, nil, nil, nil)

var dlpOrganizationsStoredInfoTypesDelete* = Call_DlpOrganizationsStoredInfoTypesDelete_580019(
    name: "dlpOrganizationsStoredInfoTypesDelete", meth: HttpMethod.HttpDelete,
    host: "dlp.googleapis.com", route: "/v2/{name}",
    validator: validate_DlpOrganizationsStoredInfoTypesDelete_580020, base: "/",
    url: url_DlpOrganizationsStoredInfoTypesDelete_580021, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersActivate_580059 = ref object of OpenApiRestCall_579421
proc url_DlpProjectsJobTriggersActivate_580061(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersActivate_580060(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Activate a job trigger. Causes the immediate execute of a trigger
  ## instead of waiting on the trigger event to occur.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the trigger to activate, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580062 = path.getOrDefault("name")
  valid_580062 = validateParameter(valid_580062, JString, required = true,
                                 default = nil)
  if valid_580062 != nil:
    section.add "name", valid_580062
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
  var valid_580063 = query.getOrDefault("upload_protocol")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "upload_protocol", valid_580063
  var valid_580064 = query.getOrDefault("fields")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "fields", valid_580064
  var valid_580065 = query.getOrDefault("quotaUser")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "quotaUser", valid_580065
  var valid_580066 = query.getOrDefault("alt")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = newJString("json"))
  if valid_580066 != nil:
    section.add "alt", valid_580066
  var valid_580067 = query.getOrDefault("oauth_token")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "oauth_token", valid_580067
  var valid_580068 = query.getOrDefault("callback")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "callback", valid_580068
  var valid_580069 = query.getOrDefault("access_token")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "access_token", valid_580069
  var valid_580070 = query.getOrDefault("uploadType")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "uploadType", valid_580070
  var valid_580071 = query.getOrDefault("key")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "key", valid_580071
  var valid_580072 = query.getOrDefault("$.xgafv")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = newJString("1"))
  if valid_580072 != nil:
    section.add "$.xgafv", valid_580072
  var valid_580073 = query.getOrDefault("prettyPrint")
  valid_580073 = validateParameter(valid_580073, JBool, required = false,
                                 default = newJBool(true))
  if valid_580073 != nil:
    section.add "prettyPrint", valid_580073
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

proc call*(call_580075: Call_DlpProjectsJobTriggersActivate_580059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activate a job trigger. Causes the immediate execute of a trigger
  ## instead of waiting on the trigger event to occur.
  ## 
  let valid = call_580075.validator(path, query, header, formData, body)
  let scheme = call_580075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580075.url(scheme.get, call_580075.host, call_580075.base,
                         call_580075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580075, url, valid)

proc call*(call_580076: Call_DlpProjectsJobTriggersActivate_580059; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsJobTriggersActivate
  ## Activate a job trigger. Causes the immediate execute of a trigger
  ## instead of waiting on the trigger event to occur.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the trigger to activate, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
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
  var path_580077 = newJObject()
  var query_580078 = newJObject()
  var body_580079 = newJObject()
  add(query_580078, "upload_protocol", newJString(uploadProtocol))
  add(query_580078, "fields", newJString(fields))
  add(query_580078, "quotaUser", newJString(quotaUser))
  add(path_580077, "name", newJString(name))
  add(query_580078, "alt", newJString(alt))
  add(query_580078, "oauth_token", newJString(oauthToken))
  add(query_580078, "callback", newJString(callback))
  add(query_580078, "access_token", newJString(accessToken))
  add(query_580078, "uploadType", newJString(uploadType))
  add(query_580078, "key", newJString(key))
  add(query_580078, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580079 = body
  add(query_580078, "prettyPrint", newJBool(prettyPrint))
  result = call_580076.call(path_580077, query_580078, nil, nil, body_580079)

var dlpProjectsJobTriggersActivate* = Call_DlpProjectsJobTriggersActivate_580059(
    name: "dlpProjectsJobTriggersActivate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{name}:activate",
    validator: validate_DlpProjectsJobTriggersActivate_580060, base: "/",
    url: url_DlpProjectsJobTriggersActivate_580061, schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsCancel_580080 = ref object of OpenApiRestCall_579421
proc url_DlpProjectsDlpJobsCancel_580082(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DlpProjectsDlpJobsCancel_580081(path: JsonNode; query: JsonNode;
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
  ##       : The name of the DlpJob resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580083 = path.getOrDefault("name")
  valid_580083 = validateParameter(valid_580083, JString, required = true,
                                 default = nil)
  if valid_580083 != nil:
    section.add "name", valid_580083
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
  var valid_580084 = query.getOrDefault("upload_protocol")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "upload_protocol", valid_580084
  var valid_580085 = query.getOrDefault("fields")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "fields", valid_580085
  var valid_580086 = query.getOrDefault("quotaUser")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "quotaUser", valid_580086
  var valid_580087 = query.getOrDefault("alt")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = newJString("json"))
  if valid_580087 != nil:
    section.add "alt", valid_580087
  var valid_580088 = query.getOrDefault("oauth_token")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "oauth_token", valid_580088
  var valid_580089 = query.getOrDefault("callback")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "callback", valid_580089
  var valid_580090 = query.getOrDefault("access_token")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "access_token", valid_580090
  var valid_580091 = query.getOrDefault("uploadType")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "uploadType", valid_580091
  var valid_580092 = query.getOrDefault("key")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "key", valid_580092
  var valid_580093 = query.getOrDefault("$.xgafv")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = newJString("1"))
  if valid_580093 != nil:
    section.add "$.xgafv", valid_580093
  var valid_580094 = query.getOrDefault("prettyPrint")
  valid_580094 = validateParameter(valid_580094, JBool, required = false,
                                 default = newJBool(true))
  if valid_580094 != nil:
    section.add "prettyPrint", valid_580094
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

proc call*(call_580096: Call_DlpProjectsDlpJobsCancel_580080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running DlpJob. The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  let valid = call_580096.validator(path, query, header, formData, body)
  let scheme = call_580096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580096.url(scheme.get, call_580096.host, call_580096.base,
                         call_580096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580096, url, valid)

proc call*(call_580097: Call_DlpProjectsDlpJobsCancel_580080; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsDlpJobsCancel
  ## Starts asynchronous cancellation on a long-running DlpJob. The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the DlpJob resource to be cancelled.
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
  var path_580098 = newJObject()
  var query_580099 = newJObject()
  var body_580100 = newJObject()
  add(query_580099, "upload_protocol", newJString(uploadProtocol))
  add(query_580099, "fields", newJString(fields))
  add(query_580099, "quotaUser", newJString(quotaUser))
  add(path_580098, "name", newJString(name))
  add(query_580099, "alt", newJString(alt))
  add(query_580099, "oauth_token", newJString(oauthToken))
  add(query_580099, "callback", newJString(callback))
  add(query_580099, "access_token", newJString(accessToken))
  add(query_580099, "uploadType", newJString(uploadType))
  add(query_580099, "key", newJString(key))
  add(query_580099, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580100 = body
  add(query_580099, "prettyPrint", newJBool(prettyPrint))
  result = call_580097.call(path_580098, query_580099, nil, nil, body_580100)

var dlpProjectsDlpJobsCancel* = Call_DlpProjectsDlpJobsCancel_580080(
    name: "dlpProjectsDlpJobsCancel", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{name}:cancel",
    validator: validate_DlpProjectsDlpJobsCancel_580081, base: "/",
    url: url_DlpProjectsDlpJobsCancel_580082, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentDeidentify_580101 = ref object of OpenApiRestCall_579421
proc url_DlpProjectsContentDeidentify_580103(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DlpProjectsContentDeidentify_580102(path: JsonNode; query: JsonNode;
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
  var valid_580104 = path.getOrDefault("parent")
  valid_580104 = validateParameter(valid_580104, JString, required = true,
                                 default = nil)
  if valid_580104 != nil:
    section.add "parent", valid_580104
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
  var valid_580105 = query.getOrDefault("upload_protocol")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "upload_protocol", valid_580105
  var valid_580106 = query.getOrDefault("fields")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "fields", valid_580106
  var valid_580107 = query.getOrDefault("quotaUser")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "quotaUser", valid_580107
  var valid_580108 = query.getOrDefault("alt")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = newJString("json"))
  if valid_580108 != nil:
    section.add "alt", valid_580108
  var valid_580109 = query.getOrDefault("oauth_token")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "oauth_token", valid_580109
  var valid_580110 = query.getOrDefault("callback")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "callback", valid_580110
  var valid_580111 = query.getOrDefault("access_token")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "access_token", valid_580111
  var valid_580112 = query.getOrDefault("uploadType")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "uploadType", valid_580112
  var valid_580113 = query.getOrDefault("key")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "key", valid_580113
  var valid_580114 = query.getOrDefault("$.xgafv")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = newJString("1"))
  if valid_580114 != nil:
    section.add "$.xgafv", valid_580114
  var valid_580115 = query.getOrDefault("prettyPrint")
  valid_580115 = validateParameter(valid_580115, JBool, required = false,
                                 default = newJBool(true))
  if valid_580115 != nil:
    section.add "prettyPrint", valid_580115
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

proc call*(call_580117: Call_DlpProjectsContentDeidentify_580101; path: JsonNode;
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
  let valid = call_580117.validator(path, query, header, formData, body)
  let scheme = call_580117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580117.url(scheme.get, call_580117.host, call_580117.base,
                         call_580117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580117, url, valid)

proc call*(call_580118: Call_DlpProjectsContentDeidentify_580101; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsContentDeidentify
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
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
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580119 = newJObject()
  var query_580120 = newJObject()
  var body_580121 = newJObject()
  add(query_580120, "upload_protocol", newJString(uploadProtocol))
  add(query_580120, "fields", newJString(fields))
  add(query_580120, "quotaUser", newJString(quotaUser))
  add(query_580120, "alt", newJString(alt))
  add(query_580120, "oauth_token", newJString(oauthToken))
  add(query_580120, "callback", newJString(callback))
  add(query_580120, "access_token", newJString(accessToken))
  add(query_580120, "uploadType", newJString(uploadType))
  add(path_580119, "parent", newJString(parent))
  add(query_580120, "key", newJString(key))
  add(query_580120, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580121 = body
  add(query_580120, "prettyPrint", newJBool(prettyPrint))
  result = call_580118.call(path_580119, query_580120, nil, nil, body_580121)

var dlpProjectsContentDeidentify* = Call_DlpProjectsContentDeidentify_580101(
    name: "dlpProjectsContentDeidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/content:deidentify",
    validator: validate_DlpProjectsContentDeidentify_580102, base: "/",
    url: url_DlpProjectsContentDeidentify_580103, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentInspect_580122 = ref object of OpenApiRestCall_579421
proc url_DlpProjectsContentInspect_580124(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DlpProjectsContentInspect_580123(path: JsonNode; query: JsonNode;
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
  var valid_580125 = path.getOrDefault("parent")
  valid_580125 = validateParameter(valid_580125, JString, required = true,
                                 default = nil)
  if valid_580125 != nil:
    section.add "parent", valid_580125
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
  var valid_580126 = query.getOrDefault("upload_protocol")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "upload_protocol", valid_580126
  var valid_580127 = query.getOrDefault("fields")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "fields", valid_580127
  var valid_580128 = query.getOrDefault("quotaUser")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "quotaUser", valid_580128
  var valid_580129 = query.getOrDefault("alt")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = newJString("json"))
  if valid_580129 != nil:
    section.add "alt", valid_580129
  var valid_580130 = query.getOrDefault("oauth_token")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "oauth_token", valid_580130
  var valid_580131 = query.getOrDefault("callback")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "callback", valid_580131
  var valid_580132 = query.getOrDefault("access_token")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "access_token", valid_580132
  var valid_580133 = query.getOrDefault("uploadType")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "uploadType", valid_580133
  var valid_580134 = query.getOrDefault("key")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "key", valid_580134
  var valid_580135 = query.getOrDefault("$.xgafv")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = newJString("1"))
  if valid_580135 != nil:
    section.add "$.xgafv", valid_580135
  var valid_580136 = query.getOrDefault("prettyPrint")
  valid_580136 = validateParameter(valid_580136, JBool, required = false,
                                 default = newJBool(true))
  if valid_580136 != nil:
    section.add "prettyPrint", valid_580136
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

proc call*(call_580138: Call_DlpProjectsContentInspect_580122; path: JsonNode;
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
  let valid = call_580138.validator(path, query, header, formData, body)
  let scheme = call_580138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580138.url(scheme.get, call_580138.host, call_580138.base,
                         call_580138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580138, url, valid)

proc call*(call_580139: Call_DlpProjectsContentInspect_580122; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580140 = newJObject()
  var query_580141 = newJObject()
  var body_580142 = newJObject()
  add(query_580141, "upload_protocol", newJString(uploadProtocol))
  add(query_580141, "fields", newJString(fields))
  add(query_580141, "quotaUser", newJString(quotaUser))
  add(query_580141, "alt", newJString(alt))
  add(query_580141, "oauth_token", newJString(oauthToken))
  add(query_580141, "callback", newJString(callback))
  add(query_580141, "access_token", newJString(accessToken))
  add(query_580141, "uploadType", newJString(uploadType))
  add(path_580140, "parent", newJString(parent))
  add(query_580141, "key", newJString(key))
  add(query_580141, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580142 = body
  add(query_580141, "prettyPrint", newJBool(prettyPrint))
  result = call_580139.call(path_580140, query_580141, nil, nil, body_580142)

var dlpProjectsContentInspect* = Call_DlpProjectsContentInspect_580122(
    name: "dlpProjectsContentInspect", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/content:inspect",
    validator: validate_DlpProjectsContentInspect_580123, base: "/",
    url: url_DlpProjectsContentInspect_580124, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentReidentify_580143 = ref object of OpenApiRestCall_579421
proc url_DlpProjectsContentReidentify_580145(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DlpProjectsContentReidentify_580144(path: JsonNode; query: JsonNode;
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
  ##         : The parent resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580146 = path.getOrDefault("parent")
  valid_580146 = validateParameter(valid_580146, JString, required = true,
                                 default = nil)
  if valid_580146 != nil:
    section.add "parent", valid_580146
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
  var valid_580147 = query.getOrDefault("upload_protocol")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "upload_protocol", valid_580147
  var valid_580148 = query.getOrDefault("fields")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "fields", valid_580148
  var valid_580149 = query.getOrDefault("quotaUser")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "quotaUser", valid_580149
  var valid_580150 = query.getOrDefault("alt")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = newJString("json"))
  if valid_580150 != nil:
    section.add "alt", valid_580150
  var valid_580151 = query.getOrDefault("oauth_token")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "oauth_token", valid_580151
  var valid_580152 = query.getOrDefault("callback")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "callback", valid_580152
  var valid_580153 = query.getOrDefault("access_token")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "access_token", valid_580153
  var valid_580154 = query.getOrDefault("uploadType")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "uploadType", valid_580154
  var valid_580155 = query.getOrDefault("key")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "key", valid_580155
  var valid_580156 = query.getOrDefault("$.xgafv")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = newJString("1"))
  if valid_580156 != nil:
    section.add "$.xgafv", valid_580156
  var valid_580157 = query.getOrDefault("prettyPrint")
  valid_580157 = validateParameter(valid_580157, JBool, required = false,
                                 default = newJBool(true))
  if valid_580157 != nil:
    section.add "prettyPrint", valid_580157
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

proc call*(call_580159: Call_DlpProjectsContentReidentify_580143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
  ## 
  let valid = call_580159.validator(path, query, header, formData, body)
  let scheme = call_580159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580159.url(scheme.get, call_580159.host, call_580159.base,
                         call_580159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580159, url, valid)

proc call*(call_580160: Call_DlpProjectsContentReidentify_580143; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsContentReidentify
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
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
  ##   parent: string (required)
  ##         : The parent resource name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580161 = newJObject()
  var query_580162 = newJObject()
  var body_580163 = newJObject()
  add(query_580162, "upload_protocol", newJString(uploadProtocol))
  add(query_580162, "fields", newJString(fields))
  add(query_580162, "quotaUser", newJString(quotaUser))
  add(query_580162, "alt", newJString(alt))
  add(query_580162, "oauth_token", newJString(oauthToken))
  add(query_580162, "callback", newJString(callback))
  add(query_580162, "access_token", newJString(accessToken))
  add(query_580162, "uploadType", newJString(uploadType))
  add(path_580161, "parent", newJString(parent))
  add(query_580162, "key", newJString(key))
  add(query_580162, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580163 = body
  add(query_580162, "prettyPrint", newJBool(prettyPrint))
  result = call_580160.call(path_580161, query_580162, nil, nil, body_580163)

var dlpProjectsContentReidentify* = Call_DlpProjectsContentReidentify_580143(
    name: "dlpProjectsContentReidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/content:reidentify",
    validator: validate_DlpProjectsContentReidentify_580144, base: "/",
    url: url_DlpProjectsContentReidentify_580145, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsDeidentifyTemplatesCreate_580186 = ref object of OpenApiRestCall_579421
proc url_DlpOrganizationsDeidentifyTemplatesCreate_580188(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_DlpOrganizationsDeidentifyTemplatesCreate_580187(path: JsonNode;
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
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580189 = path.getOrDefault("parent")
  valid_580189 = validateParameter(valid_580189, JString, required = true,
                                 default = nil)
  if valid_580189 != nil:
    section.add "parent", valid_580189
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
  var valid_580190 = query.getOrDefault("upload_protocol")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "upload_protocol", valid_580190
  var valid_580191 = query.getOrDefault("fields")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "fields", valid_580191
  var valid_580192 = query.getOrDefault("quotaUser")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "quotaUser", valid_580192
  var valid_580193 = query.getOrDefault("alt")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = newJString("json"))
  if valid_580193 != nil:
    section.add "alt", valid_580193
  var valid_580194 = query.getOrDefault("oauth_token")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "oauth_token", valid_580194
  var valid_580195 = query.getOrDefault("callback")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "callback", valid_580195
  var valid_580196 = query.getOrDefault("access_token")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "access_token", valid_580196
  var valid_580197 = query.getOrDefault("uploadType")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "uploadType", valid_580197
  var valid_580198 = query.getOrDefault("key")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "key", valid_580198
  var valid_580199 = query.getOrDefault("$.xgafv")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = newJString("1"))
  if valid_580199 != nil:
    section.add "$.xgafv", valid_580199
  var valid_580200 = query.getOrDefault("prettyPrint")
  valid_580200 = validateParameter(valid_580200, JBool, required = false,
                                 default = newJBool(true))
  if valid_580200 != nil:
    section.add "prettyPrint", valid_580200
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

proc call*(call_580202: Call_DlpOrganizationsDeidentifyTemplatesCreate_580186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a DeidentifyTemplate for re-using frequently used configuration
  ## for de-identifying content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ## 
  let valid = call_580202.validator(path, query, header, formData, body)
  let scheme = call_580202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580202.url(scheme.get, call_580202.host, call_580202.base,
                         call_580202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580202, url, valid)

proc call*(call_580203: Call_DlpOrganizationsDeidentifyTemplatesCreate_580186;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dlpOrganizationsDeidentifyTemplatesCreate
  ## Creates a DeidentifyTemplate for re-using frequently used configuration
  ## for de-identifying content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
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
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580204 = newJObject()
  var query_580205 = newJObject()
  var body_580206 = newJObject()
  add(query_580205, "upload_protocol", newJString(uploadProtocol))
  add(query_580205, "fields", newJString(fields))
  add(query_580205, "quotaUser", newJString(quotaUser))
  add(query_580205, "alt", newJString(alt))
  add(query_580205, "oauth_token", newJString(oauthToken))
  add(query_580205, "callback", newJString(callback))
  add(query_580205, "access_token", newJString(accessToken))
  add(query_580205, "uploadType", newJString(uploadType))
  add(path_580204, "parent", newJString(parent))
  add(query_580205, "key", newJString(key))
  add(query_580205, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580206 = body
  add(query_580205, "prettyPrint", newJBool(prettyPrint))
  result = call_580203.call(path_580204, query_580205, nil, nil, body_580206)

var dlpOrganizationsDeidentifyTemplatesCreate* = Call_DlpOrganizationsDeidentifyTemplatesCreate_580186(
    name: "dlpOrganizationsDeidentifyTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/deidentifyTemplates",
    validator: validate_DlpOrganizationsDeidentifyTemplatesCreate_580187,
    base: "/", url: url_DlpOrganizationsDeidentifyTemplatesCreate_580188,
    schemes: {Scheme.Https})
type
  Call_DlpOrganizationsDeidentifyTemplatesList_580164 = ref object of OpenApiRestCall_579421
proc url_DlpOrganizationsDeidentifyTemplatesList_580166(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_DlpOrganizationsDeidentifyTemplatesList_580165(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists DeidentifyTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580167 = path.getOrDefault("parent")
  valid_580167 = validateParameter(valid_580167, JString, required = true,
                                 default = nil)
  if valid_580167 != nil:
    section.add "parent", valid_580167
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListDeidentifyTemplates`.
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580168 = query.getOrDefault("upload_protocol")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "upload_protocol", valid_580168
  var valid_580169 = query.getOrDefault("fields")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "fields", valid_580169
  var valid_580170 = query.getOrDefault("pageToken")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "pageToken", valid_580170
  var valid_580171 = query.getOrDefault("quotaUser")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "quotaUser", valid_580171
  var valid_580172 = query.getOrDefault("alt")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = newJString("json"))
  if valid_580172 != nil:
    section.add "alt", valid_580172
  var valid_580173 = query.getOrDefault("oauth_token")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "oauth_token", valid_580173
  var valid_580174 = query.getOrDefault("callback")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "callback", valid_580174
  var valid_580175 = query.getOrDefault("access_token")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "access_token", valid_580175
  var valid_580176 = query.getOrDefault("uploadType")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "uploadType", valid_580176
  var valid_580177 = query.getOrDefault("orderBy")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "orderBy", valid_580177
  var valid_580178 = query.getOrDefault("key")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "key", valid_580178
  var valid_580179 = query.getOrDefault("$.xgafv")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = newJString("1"))
  if valid_580179 != nil:
    section.add "$.xgafv", valid_580179
  var valid_580180 = query.getOrDefault("pageSize")
  valid_580180 = validateParameter(valid_580180, JInt, required = false, default = nil)
  if valid_580180 != nil:
    section.add "pageSize", valid_580180
  var valid_580181 = query.getOrDefault("prettyPrint")
  valid_580181 = validateParameter(valid_580181, JBool, required = false,
                                 default = newJBool(true))
  if valid_580181 != nil:
    section.add "prettyPrint", valid_580181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580182: Call_DlpOrganizationsDeidentifyTemplatesList_580164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists DeidentifyTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ## 
  let valid = call_580182.validator(path, query, header, formData, body)
  let scheme = call_580182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580182.url(scheme.get, call_580182.host, call_580182.base,
                         call_580182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580182, url, valid)

proc call*(call_580183: Call_DlpOrganizationsDeidentifyTemplatesList_580164;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## dlpOrganizationsDeidentifyTemplatesList
  ## Lists DeidentifyTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListDeidentifyTemplates`.
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
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580184 = newJObject()
  var query_580185 = newJObject()
  add(query_580185, "upload_protocol", newJString(uploadProtocol))
  add(query_580185, "fields", newJString(fields))
  add(query_580185, "pageToken", newJString(pageToken))
  add(query_580185, "quotaUser", newJString(quotaUser))
  add(query_580185, "alt", newJString(alt))
  add(query_580185, "oauth_token", newJString(oauthToken))
  add(query_580185, "callback", newJString(callback))
  add(query_580185, "access_token", newJString(accessToken))
  add(query_580185, "uploadType", newJString(uploadType))
  add(path_580184, "parent", newJString(parent))
  add(query_580185, "orderBy", newJString(orderBy))
  add(query_580185, "key", newJString(key))
  add(query_580185, "$.xgafv", newJString(Xgafv))
  add(query_580185, "pageSize", newJInt(pageSize))
  add(query_580185, "prettyPrint", newJBool(prettyPrint))
  result = call_580183.call(path_580184, query_580185, nil, nil, nil)

var dlpOrganizationsDeidentifyTemplatesList* = Call_DlpOrganizationsDeidentifyTemplatesList_580164(
    name: "dlpOrganizationsDeidentifyTemplatesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/deidentifyTemplates",
    validator: validate_DlpOrganizationsDeidentifyTemplatesList_580165, base: "/",
    url: url_DlpOrganizationsDeidentifyTemplatesList_580166,
    schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsCreate_580231 = ref object of OpenApiRestCall_579421
proc url_DlpProjectsDlpJobsCreate_580233(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DlpProjectsDlpJobsCreate_580232(path: JsonNode; query: JsonNode;
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
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580234 = path.getOrDefault("parent")
  valid_580234 = validateParameter(valid_580234, JString, required = true,
                                 default = nil)
  if valid_580234 != nil:
    section.add "parent", valid_580234
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
  var valid_580235 = query.getOrDefault("upload_protocol")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "upload_protocol", valid_580235
  var valid_580236 = query.getOrDefault("fields")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "fields", valid_580236
  var valid_580237 = query.getOrDefault("quotaUser")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "quotaUser", valid_580237
  var valid_580238 = query.getOrDefault("alt")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = newJString("json"))
  if valid_580238 != nil:
    section.add "alt", valid_580238
  var valid_580239 = query.getOrDefault("oauth_token")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "oauth_token", valid_580239
  var valid_580240 = query.getOrDefault("callback")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "callback", valid_580240
  var valid_580241 = query.getOrDefault("access_token")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "access_token", valid_580241
  var valid_580242 = query.getOrDefault("uploadType")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "uploadType", valid_580242
  var valid_580243 = query.getOrDefault("key")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "key", valid_580243
  var valid_580244 = query.getOrDefault("$.xgafv")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = newJString("1"))
  if valid_580244 != nil:
    section.add "$.xgafv", valid_580244
  var valid_580245 = query.getOrDefault("prettyPrint")
  valid_580245 = validateParameter(valid_580245, JBool, required = false,
                                 default = newJBool(true))
  if valid_580245 != nil:
    section.add "prettyPrint", valid_580245
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

proc call*(call_580247: Call_DlpProjectsDlpJobsCreate_580231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new job to inspect storage or calculate risk metrics.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in inspect jobs, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  let valid = call_580247.validator(path, query, header, formData, body)
  let scheme = call_580247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580247.url(scheme.get, call_580247.host, call_580247.base,
                         call_580247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580247, url, valid)

proc call*(call_580248: Call_DlpProjectsDlpJobsCreate_580231; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsDlpJobsCreate
  ## Creates a new job to inspect storage or calculate risk metrics.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in inspect jobs, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
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
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580249 = newJObject()
  var query_580250 = newJObject()
  var body_580251 = newJObject()
  add(query_580250, "upload_protocol", newJString(uploadProtocol))
  add(query_580250, "fields", newJString(fields))
  add(query_580250, "quotaUser", newJString(quotaUser))
  add(query_580250, "alt", newJString(alt))
  add(query_580250, "oauth_token", newJString(oauthToken))
  add(query_580250, "callback", newJString(callback))
  add(query_580250, "access_token", newJString(accessToken))
  add(query_580250, "uploadType", newJString(uploadType))
  add(path_580249, "parent", newJString(parent))
  add(query_580250, "key", newJString(key))
  add(query_580250, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580251 = body
  add(query_580250, "prettyPrint", newJBool(prettyPrint))
  result = call_580248.call(path_580249, query_580250, nil, nil, body_580251)

var dlpProjectsDlpJobsCreate* = Call_DlpProjectsDlpJobsCreate_580231(
    name: "dlpProjectsDlpJobsCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/dlpJobs",
    validator: validate_DlpProjectsDlpJobsCreate_580232, base: "/",
    url: url_DlpProjectsDlpJobsCreate_580233, schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsList_580207 = ref object of OpenApiRestCall_579421
proc url_DlpProjectsDlpJobsList_580209(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DlpProjectsDlpJobsList_580208(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists DlpJobs that match the specified filter in the request.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580210 = path.getOrDefault("parent")
  valid_580210 = validateParameter(valid_580210, JString, required = true,
                                 default = nil)
  if valid_580210 != nil:
    section.add "parent", valid_580210
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   type: JString
  ##       : The type of job. Defaults to `DlpJobType.INSPECT`
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
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
  section = newJObject()
  var valid_580211 = query.getOrDefault("upload_protocol")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "upload_protocol", valid_580211
  var valid_580212 = query.getOrDefault("fields")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "fields", valid_580212
  var valid_580213 = query.getOrDefault("pageToken")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "pageToken", valid_580213
  var valid_580214 = query.getOrDefault("quotaUser")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "quotaUser", valid_580214
  var valid_580215 = query.getOrDefault("alt")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = newJString("json"))
  if valid_580215 != nil:
    section.add "alt", valid_580215
  var valid_580216 = query.getOrDefault("type")
  valid_580216 = validateParameter(valid_580216, JString, required = false, default = newJString(
      "DLP_JOB_TYPE_UNSPECIFIED"))
  if valid_580216 != nil:
    section.add "type", valid_580216
  var valid_580217 = query.getOrDefault("oauth_token")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "oauth_token", valid_580217
  var valid_580218 = query.getOrDefault("callback")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "callback", valid_580218
  var valid_580219 = query.getOrDefault("access_token")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "access_token", valid_580219
  var valid_580220 = query.getOrDefault("uploadType")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "uploadType", valid_580220
  var valid_580221 = query.getOrDefault("orderBy")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "orderBy", valid_580221
  var valid_580222 = query.getOrDefault("key")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "key", valid_580222
  var valid_580223 = query.getOrDefault("$.xgafv")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = newJString("1"))
  if valid_580223 != nil:
    section.add "$.xgafv", valid_580223
  var valid_580224 = query.getOrDefault("pageSize")
  valid_580224 = validateParameter(valid_580224, JInt, required = false, default = nil)
  if valid_580224 != nil:
    section.add "pageSize", valid_580224
  var valid_580225 = query.getOrDefault("prettyPrint")
  valid_580225 = validateParameter(valid_580225, JBool, required = false,
                                 default = newJBool(true))
  if valid_580225 != nil:
    section.add "prettyPrint", valid_580225
  var valid_580226 = query.getOrDefault("filter")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "filter", valid_580226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580227: Call_DlpProjectsDlpJobsList_580207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists DlpJobs that match the specified filter in the request.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  let valid = call_580227.validator(path, query, header, formData, body)
  let scheme = call_580227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580227.url(scheme.get, call_580227.host, call_580227.base,
                         call_580227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580227, url, valid)

proc call*(call_580228: Call_DlpProjectsDlpJobsList_580207; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json";
          `type`: string = "DLP_JOB_TYPE_UNSPECIFIED"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          orderBy: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## dlpProjectsDlpJobsList
  ## Lists DlpJobs that match the specified filter in the request.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   type: string
  ##       : The type of job. Defaults to `DlpJobType.INSPECT`
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
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
  var path_580229 = newJObject()
  var query_580230 = newJObject()
  add(query_580230, "upload_protocol", newJString(uploadProtocol))
  add(query_580230, "fields", newJString(fields))
  add(query_580230, "pageToken", newJString(pageToken))
  add(query_580230, "quotaUser", newJString(quotaUser))
  add(query_580230, "alt", newJString(alt))
  add(query_580230, "type", newJString(`type`))
  add(query_580230, "oauth_token", newJString(oauthToken))
  add(query_580230, "callback", newJString(callback))
  add(query_580230, "access_token", newJString(accessToken))
  add(query_580230, "uploadType", newJString(uploadType))
  add(path_580229, "parent", newJString(parent))
  add(query_580230, "orderBy", newJString(orderBy))
  add(query_580230, "key", newJString(key))
  add(query_580230, "$.xgafv", newJString(Xgafv))
  add(query_580230, "pageSize", newJInt(pageSize))
  add(query_580230, "prettyPrint", newJBool(prettyPrint))
  add(query_580230, "filter", newJString(filter))
  result = call_580228.call(path_580229, query_580230, nil, nil, nil)

var dlpProjectsDlpJobsList* = Call_DlpProjectsDlpJobsList_580207(
    name: "dlpProjectsDlpJobsList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/dlpJobs",
    validator: validate_DlpProjectsDlpJobsList_580208, base: "/",
    url: url_DlpProjectsDlpJobsList_580209, schemes: {Scheme.Https})
type
  Call_DlpProjectsImageRedact_580252 = ref object of OpenApiRestCall_579421
proc url_DlpProjectsImageRedact_580254(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DlpProjectsImageRedact_580253(path: JsonNode; query: JsonNode;
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
  var valid_580255 = path.getOrDefault("parent")
  valid_580255 = validateParameter(valid_580255, JString, required = true,
                                 default = nil)
  if valid_580255 != nil:
    section.add "parent", valid_580255
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
  var valid_580256 = query.getOrDefault("upload_protocol")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "upload_protocol", valid_580256
  var valid_580257 = query.getOrDefault("fields")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "fields", valid_580257
  var valid_580258 = query.getOrDefault("quotaUser")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "quotaUser", valid_580258
  var valid_580259 = query.getOrDefault("alt")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = newJString("json"))
  if valid_580259 != nil:
    section.add "alt", valid_580259
  var valid_580260 = query.getOrDefault("oauth_token")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "oauth_token", valid_580260
  var valid_580261 = query.getOrDefault("callback")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "callback", valid_580261
  var valid_580262 = query.getOrDefault("access_token")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "access_token", valid_580262
  var valid_580263 = query.getOrDefault("uploadType")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "uploadType", valid_580263
  var valid_580264 = query.getOrDefault("key")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "key", valid_580264
  var valid_580265 = query.getOrDefault("$.xgafv")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = newJString("1"))
  if valid_580265 != nil:
    section.add "$.xgafv", valid_580265
  var valid_580266 = query.getOrDefault("prettyPrint")
  valid_580266 = validateParameter(valid_580266, JBool, required = false,
                                 default = newJBool(true))
  if valid_580266 != nil:
    section.add "prettyPrint", valid_580266
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

proc call*(call_580268: Call_DlpProjectsImageRedact_580252; path: JsonNode;
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
  let valid = call_580268.validator(path, query, header, formData, body)
  let scheme = call_580268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580268.url(scheme.get, call_580268.host, call_580268.base,
                         call_580268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580268, url, valid)

proc call*(call_580269: Call_DlpProjectsImageRedact_580252; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsImageRedact
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## See https://cloud.google.com/dlp/docs/redacting-sensitive-data-images to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
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
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580270 = newJObject()
  var query_580271 = newJObject()
  var body_580272 = newJObject()
  add(query_580271, "upload_protocol", newJString(uploadProtocol))
  add(query_580271, "fields", newJString(fields))
  add(query_580271, "quotaUser", newJString(quotaUser))
  add(query_580271, "alt", newJString(alt))
  add(query_580271, "oauth_token", newJString(oauthToken))
  add(query_580271, "callback", newJString(callback))
  add(query_580271, "access_token", newJString(accessToken))
  add(query_580271, "uploadType", newJString(uploadType))
  add(path_580270, "parent", newJString(parent))
  add(query_580271, "key", newJString(key))
  add(query_580271, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580272 = body
  add(query_580271, "prettyPrint", newJBool(prettyPrint))
  result = call_580269.call(path_580270, query_580271, nil, nil, body_580272)

var dlpProjectsImageRedact* = Call_DlpProjectsImageRedact_580252(
    name: "dlpProjectsImageRedact", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/image:redact",
    validator: validate_DlpProjectsImageRedact_580253, base: "/",
    url: url_DlpProjectsImageRedact_580254, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsInspectTemplatesCreate_580295 = ref object of OpenApiRestCall_579421
proc url_DlpOrganizationsInspectTemplatesCreate_580297(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_DlpOrganizationsInspectTemplatesCreate_580296(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an InspectTemplate for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580298 = path.getOrDefault("parent")
  valid_580298 = validateParameter(valid_580298, JString, required = true,
                                 default = nil)
  if valid_580298 != nil:
    section.add "parent", valid_580298
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
  var valid_580299 = query.getOrDefault("upload_protocol")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "upload_protocol", valid_580299
  var valid_580300 = query.getOrDefault("fields")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "fields", valid_580300
  var valid_580301 = query.getOrDefault("quotaUser")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "quotaUser", valid_580301
  var valid_580302 = query.getOrDefault("alt")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = newJString("json"))
  if valid_580302 != nil:
    section.add "alt", valid_580302
  var valid_580303 = query.getOrDefault("oauth_token")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "oauth_token", valid_580303
  var valid_580304 = query.getOrDefault("callback")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "callback", valid_580304
  var valid_580305 = query.getOrDefault("access_token")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "access_token", valid_580305
  var valid_580306 = query.getOrDefault("uploadType")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "uploadType", valid_580306
  var valid_580307 = query.getOrDefault("key")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "key", valid_580307
  var valid_580308 = query.getOrDefault("$.xgafv")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = newJString("1"))
  if valid_580308 != nil:
    section.add "$.xgafv", valid_580308
  var valid_580309 = query.getOrDefault("prettyPrint")
  valid_580309 = validateParameter(valid_580309, JBool, required = false,
                                 default = newJBool(true))
  if valid_580309 != nil:
    section.add "prettyPrint", valid_580309
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

proc call*(call_580311: Call_DlpOrganizationsInspectTemplatesCreate_580295;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an InspectTemplate for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  let valid = call_580311.validator(path, query, header, formData, body)
  let scheme = call_580311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580311.url(scheme.get, call_580311.host, call_580311.base,
                         call_580311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580311, url, valid)

proc call*(call_580312: Call_DlpOrganizationsInspectTemplatesCreate_580295;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dlpOrganizationsInspectTemplatesCreate
  ## Creates an InspectTemplate for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
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
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580313 = newJObject()
  var query_580314 = newJObject()
  var body_580315 = newJObject()
  add(query_580314, "upload_protocol", newJString(uploadProtocol))
  add(query_580314, "fields", newJString(fields))
  add(query_580314, "quotaUser", newJString(quotaUser))
  add(query_580314, "alt", newJString(alt))
  add(query_580314, "oauth_token", newJString(oauthToken))
  add(query_580314, "callback", newJString(callback))
  add(query_580314, "access_token", newJString(accessToken))
  add(query_580314, "uploadType", newJString(uploadType))
  add(path_580313, "parent", newJString(parent))
  add(query_580314, "key", newJString(key))
  add(query_580314, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580315 = body
  add(query_580314, "prettyPrint", newJBool(prettyPrint))
  result = call_580312.call(path_580313, query_580314, nil, nil, body_580315)

var dlpOrganizationsInspectTemplatesCreate* = Call_DlpOrganizationsInspectTemplatesCreate_580295(
    name: "dlpOrganizationsInspectTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/inspectTemplates",
    validator: validate_DlpOrganizationsInspectTemplatesCreate_580296, base: "/",
    url: url_DlpOrganizationsInspectTemplatesCreate_580297,
    schemes: {Scheme.Https})
type
  Call_DlpOrganizationsInspectTemplatesList_580273 = ref object of OpenApiRestCall_579421
proc url_DlpOrganizationsInspectTemplatesList_580275(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_DlpOrganizationsInspectTemplatesList_580274(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists InspectTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580276 = path.getOrDefault("parent")
  valid_580276 = validateParameter(valid_580276, JString, required = true,
                                 default = nil)
  if valid_580276 != nil:
    section.add "parent", valid_580276
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListInspectTemplates`.
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580277 = query.getOrDefault("upload_protocol")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "upload_protocol", valid_580277
  var valid_580278 = query.getOrDefault("fields")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "fields", valid_580278
  var valid_580279 = query.getOrDefault("pageToken")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "pageToken", valid_580279
  var valid_580280 = query.getOrDefault("quotaUser")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "quotaUser", valid_580280
  var valid_580281 = query.getOrDefault("alt")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = newJString("json"))
  if valid_580281 != nil:
    section.add "alt", valid_580281
  var valid_580282 = query.getOrDefault("oauth_token")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "oauth_token", valid_580282
  var valid_580283 = query.getOrDefault("callback")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "callback", valid_580283
  var valid_580284 = query.getOrDefault("access_token")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "access_token", valid_580284
  var valid_580285 = query.getOrDefault("uploadType")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "uploadType", valid_580285
  var valid_580286 = query.getOrDefault("orderBy")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "orderBy", valid_580286
  var valid_580287 = query.getOrDefault("key")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "key", valid_580287
  var valid_580288 = query.getOrDefault("$.xgafv")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = newJString("1"))
  if valid_580288 != nil:
    section.add "$.xgafv", valid_580288
  var valid_580289 = query.getOrDefault("pageSize")
  valid_580289 = validateParameter(valid_580289, JInt, required = false, default = nil)
  if valid_580289 != nil:
    section.add "pageSize", valid_580289
  var valid_580290 = query.getOrDefault("prettyPrint")
  valid_580290 = validateParameter(valid_580290, JBool, required = false,
                                 default = newJBool(true))
  if valid_580290 != nil:
    section.add "prettyPrint", valid_580290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580291: Call_DlpOrganizationsInspectTemplatesList_580273;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists InspectTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  let valid = call_580291.validator(path, query, header, formData, body)
  let scheme = call_580291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580291.url(scheme.get, call_580291.host, call_580291.base,
                         call_580291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580291, url, valid)

proc call*(call_580292: Call_DlpOrganizationsInspectTemplatesList_580273;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## dlpOrganizationsInspectTemplatesList
  ## Lists InspectTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListInspectTemplates`.
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
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580293 = newJObject()
  var query_580294 = newJObject()
  add(query_580294, "upload_protocol", newJString(uploadProtocol))
  add(query_580294, "fields", newJString(fields))
  add(query_580294, "pageToken", newJString(pageToken))
  add(query_580294, "quotaUser", newJString(quotaUser))
  add(query_580294, "alt", newJString(alt))
  add(query_580294, "oauth_token", newJString(oauthToken))
  add(query_580294, "callback", newJString(callback))
  add(query_580294, "access_token", newJString(accessToken))
  add(query_580294, "uploadType", newJString(uploadType))
  add(path_580293, "parent", newJString(parent))
  add(query_580294, "orderBy", newJString(orderBy))
  add(query_580294, "key", newJString(key))
  add(query_580294, "$.xgafv", newJString(Xgafv))
  add(query_580294, "pageSize", newJInt(pageSize))
  add(query_580294, "prettyPrint", newJBool(prettyPrint))
  result = call_580292.call(path_580293, query_580294, nil, nil, nil)

var dlpOrganizationsInspectTemplatesList* = Call_DlpOrganizationsInspectTemplatesList_580273(
    name: "dlpOrganizationsInspectTemplatesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/inspectTemplates",
    validator: validate_DlpOrganizationsInspectTemplatesList_580274, base: "/",
    url: url_DlpOrganizationsInspectTemplatesList_580275, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersCreate_580339 = ref object of OpenApiRestCall_579421
proc url_DlpProjectsJobTriggersCreate_580341(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersCreate_580340(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a job trigger to run DLP actions such as scanning storage for
  ## sensitive information on a set schedule.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580342 = path.getOrDefault("parent")
  valid_580342 = validateParameter(valid_580342, JString, required = true,
                                 default = nil)
  if valid_580342 != nil:
    section.add "parent", valid_580342
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
  var valid_580343 = query.getOrDefault("upload_protocol")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "upload_protocol", valid_580343
  var valid_580344 = query.getOrDefault("fields")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "fields", valid_580344
  var valid_580345 = query.getOrDefault("quotaUser")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "quotaUser", valid_580345
  var valid_580346 = query.getOrDefault("alt")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = newJString("json"))
  if valid_580346 != nil:
    section.add "alt", valid_580346
  var valid_580347 = query.getOrDefault("oauth_token")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "oauth_token", valid_580347
  var valid_580348 = query.getOrDefault("callback")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "callback", valid_580348
  var valid_580349 = query.getOrDefault("access_token")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "access_token", valid_580349
  var valid_580350 = query.getOrDefault("uploadType")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "uploadType", valid_580350
  var valid_580351 = query.getOrDefault("key")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "key", valid_580351
  var valid_580352 = query.getOrDefault("$.xgafv")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = newJString("1"))
  if valid_580352 != nil:
    section.add "$.xgafv", valid_580352
  var valid_580353 = query.getOrDefault("prettyPrint")
  valid_580353 = validateParameter(valid_580353, JBool, required = false,
                                 default = newJBool(true))
  if valid_580353 != nil:
    section.add "prettyPrint", valid_580353
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

proc call*(call_580355: Call_DlpProjectsJobTriggersCreate_580339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a job trigger to run DLP actions such as scanning storage for
  ## sensitive information on a set schedule.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ## 
  let valid = call_580355.validator(path, query, header, formData, body)
  let scheme = call_580355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580355.url(scheme.get, call_580355.host, call_580355.base,
                         call_580355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580355, url, valid)

proc call*(call_580356: Call_DlpProjectsJobTriggersCreate_580339; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsJobTriggersCreate
  ## Creates a job trigger to run DLP actions such as scanning storage for
  ## sensitive information on a set schedule.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
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
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580357 = newJObject()
  var query_580358 = newJObject()
  var body_580359 = newJObject()
  add(query_580358, "upload_protocol", newJString(uploadProtocol))
  add(query_580358, "fields", newJString(fields))
  add(query_580358, "quotaUser", newJString(quotaUser))
  add(query_580358, "alt", newJString(alt))
  add(query_580358, "oauth_token", newJString(oauthToken))
  add(query_580358, "callback", newJString(callback))
  add(query_580358, "access_token", newJString(accessToken))
  add(query_580358, "uploadType", newJString(uploadType))
  add(path_580357, "parent", newJString(parent))
  add(query_580358, "key", newJString(key))
  add(query_580358, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580359 = body
  add(query_580358, "prettyPrint", newJBool(prettyPrint))
  result = call_580356.call(path_580357, query_580358, nil, nil, body_580359)

var dlpProjectsJobTriggersCreate* = Call_DlpProjectsJobTriggersCreate_580339(
    name: "dlpProjectsJobTriggersCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/jobTriggers",
    validator: validate_DlpProjectsJobTriggersCreate_580340, base: "/",
    url: url_DlpProjectsJobTriggersCreate_580341, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersList_580316 = ref object of OpenApiRestCall_579421
proc url_DlpProjectsJobTriggersList_580318(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersList_580317(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists job triggers.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example `projects/my-project-id`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580319 = path.getOrDefault("parent")
  valid_580319 = validateParameter(valid_580319, JString, required = true,
                                 default = nil)
  if valid_580319 != nil:
    section.add "parent", valid_580319
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to ListJobTriggers. `order_by` field must not
  ## change for subsequent calls.
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by a server.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
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
  section = newJObject()
  var valid_580320 = query.getOrDefault("upload_protocol")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "upload_protocol", valid_580320
  var valid_580321 = query.getOrDefault("fields")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "fields", valid_580321
  var valid_580322 = query.getOrDefault("pageToken")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "pageToken", valid_580322
  var valid_580323 = query.getOrDefault("quotaUser")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "quotaUser", valid_580323
  var valid_580324 = query.getOrDefault("alt")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = newJString("json"))
  if valid_580324 != nil:
    section.add "alt", valid_580324
  var valid_580325 = query.getOrDefault("oauth_token")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "oauth_token", valid_580325
  var valid_580326 = query.getOrDefault("callback")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "callback", valid_580326
  var valid_580327 = query.getOrDefault("access_token")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "access_token", valid_580327
  var valid_580328 = query.getOrDefault("uploadType")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "uploadType", valid_580328
  var valid_580329 = query.getOrDefault("orderBy")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "orderBy", valid_580329
  var valid_580330 = query.getOrDefault("key")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "key", valid_580330
  var valid_580331 = query.getOrDefault("$.xgafv")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = newJString("1"))
  if valid_580331 != nil:
    section.add "$.xgafv", valid_580331
  var valid_580332 = query.getOrDefault("pageSize")
  valid_580332 = validateParameter(valid_580332, JInt, required = false, default = nil)
  if valid_580332 != nil:
    section.add "pageSize", valid_580332
  var valid_580333 = query.getOrDefault("prettyPrint")
  valid_580333 = validateParameter(valid_580333, JBool, required = false,
                                 default = newJBool(true))
  if valid_580333 != nil:
    section.add "prettyPrint", valid_580333
  var valid_580334 = query.getOrDefault("filter")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "filter", valid_580334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580335: Call_DlpProjectsJobTriggersList_580316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists job triggers.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ## 
  let valid = call_580335.validator(path, query, header, formData, body)
  let scheme = call_580335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580335.url(scheme.get, call_580335.host, call_580335.base,
                         call_580335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580335, url, valid)

proc call*(call_580336: Call_DlpProjectsJobTriggersList_580316; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          orderBy: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## dlpProjectsJobTriggersList
  ## Lists job triggers.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to ListJobTriggers. `order_by` field must not
  ## change for subsequent calls.
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
  ##   parent: string (required)
  ##         : The parent resource name, for example `projects/my-project-id`.
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by a server.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
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
  var path_580337 = newJObject()
  var query_580338 = newJObject()
  add(query_580338, "upload_protocol", newJString(uploadProtocol))
  add(query_580338, "fields", newJString(fields))
  add(query_580338, "pageToken", newJString(pageToken))
  add(query_580338, "quotaUser", newJString(quotaUser))
  add(query_580338, "alt", newJString(alt))
  add(query_580338, "oauth_token", newJString(oauthToken))
  add(query_580338, "callback", newJString(callback))
  add(query_580338, "access_token", newJString(accessToken))
  add(query_580338, "uploadType", newJString(uploadType))
  add(path_580337, "parent", newJString(parent))
  add(query_580338, "orderBy", newJString(orderBy))
  add(query_580338, "key", newJString(key))
  add(query_580338, "$.xgafv", newJString(Xgafv))
  add(query_580338, "pageSize", newJInt(pageSize))
  add(query_580338, "prettyPrint", newJBool(prettyPrint))
  add(query_580338, "filter", newJString(filter))
  result = call_580336.call(path_580337, query_580338, nil, nil, nil)

var dlpProjectsJobTriggersList* = Call_DlpProjectsJobTriggersList_580316(
    name: "dlpProjectsJobTriggersList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/jobTriggers",
    validator: validate_DlpProjectsJobTriggersList_580317, base: "/",
    url: url_DlpProjectsJobTriggersList_580318, schemes: {Scheme.Https})
type
  Call_DlpProjectsLocationsContentDeidentify_580360 = ref object of OpenApiRestCall_579421
proc url_DlpProjectsLocationsContentDeidentify_580362(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_DlpProjectsLocationsContentDeidentify_580361(path: JsonNode;
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
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   location: JString (required)
  ##           : The geographic location to process de-identification. Reserved for future
  ## extensions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580363 = path.getOrDefault("parent")
  valid_580363 = validateParameter(valid_580363, JString, required = true,
                                 default = nil)
  if valid_580363 != nil:
    section.add "parent", valid_580363
  var valid_580364 = path.getOrDefault("location")
  valid_580364 = validateParameter(valid_580364, JString, required = true,
                                 default = nil)
  if valid_580364 != nil:
    section.add "location", valid_580364
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
  var valid_580365 = query.getOrDefault("upload_protocol")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "upload_protocol", valid_580365
  var valid_580366 = query.getOrDefault("fields")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "fields", valid_580366
  var valid_580367 = query.getOrDefault("quotaUser")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "quotaUser", valid_580367
  var valid_580368 = query.getOrDefault("alt")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = newJString("json"))
  if valid_580368 != nil:
    section.add "alt", valid_580368
  var valid_580369 = query.getOrDefault("oauth_token")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "oauth_token", valid_580369
  var valid_580370 = query.getOrDefault("callback")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "callback", valid_580370
  var valid_580371 = query.getOrDefault("access_token")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "access_token", valid_580371
  var valid_580372 = query.getOrDefault("uploadType")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "uploadType", valid_580372
  var valid_580373 = query.getOrDefault("key")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "key", valid_580373
  var valid_580374 = query.getOrDefault("$.xgafv")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = newJString("1"))
  if valid_580374 != nil:
    section.add "$.xgafv", valid_580374
  var valid_580375 = query.getOrDefault("prettyPrint")
  valid_580375 = validateParameter(valid_580375, JBool, required = false,
                                 default = newJBool(true))
  if valid_580375 != nil:
    section.add "prettyPrint", valid_580375
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

proc call*(call_580377: Call_DlpProjectsLocationsContentDeidentify_580360;
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
  let valid = call_580377.validator(path, query, header, formData, body)
  let scheme = call_580377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580377.url(scheme.get, call_580377.host, call_580377.base,
                         call_580377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580377, url, valid)

proc call*(call_580378: Call_DlpProjectsLocationsContentDeidentify_580360;
          parent: string; location: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsLocationsContentDeidentify
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## See https://cloud.google.com/dlp/docs/deidentify-sensitive-data to
  ## learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in this request, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
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
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The geographic location to process de-identification. Reserved for future
  ## extensions.
  var path_580379 = newJObject()
  var query_580380 = newJObject()
  var body_580381 = newJObject()
  add(query_580380, "upload_protocol", newJString(uploadProtocol))
  add(query_580380, "fields", newJString(fields))
  add(query_580380, "quotaUser", newJString(quotaUser))
  add(query_580380, "alt", newJString(alt))
  add(query_580380, "oauth_token", newJString(oauthToken))
  add(query_580380, "callback", newJString(callback))
  add(query_580380, "access_token", newJString(accessToken))
  add(query_580380, "uploadType", newJString(uploadType))
  add(path_580379, "parent", newJString(parent))
  add(query_580380, "key", newJString(key))
  add(query_580380, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580381 = body
  add(query_580380, "prettyPrint", newJBool(prettyPrint))
  add(path_580379, "location", newJString(location))
  result = call_580378.call(path_580379, query_580380, nil, nil, body_580381)

var dlpProjectsLocationsContentDeidentify* = Call_DlpProjectsLocationsContentDeidentify_580360(
    name: "dlpProjectsLocationsContentDeidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com",
    route: "/v2/{parent}/locations/{location}/content:deidentify",
    validator: validate_DlpProjectsLocationsContentDeidentify_580361, base: "/",
    url: url_DlpProjectsLocationsContentDeidentify_580362, schemes: {Scheme.Https})
type
  Call_DlpProjectsLocationsContentInspect_580382 = ref object of OpenApiRestCall_579421
proc url_DlpProjectsLocationsContentInspect_580384(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DlpProjectsLocationsContentInspect_580383(path: JsonNode;
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
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   location: JString (required)
  ##           : The geographic location to process content inspection. Reserved for future
  ## extensions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580385 = path.getOrDefault("parent")
  valid_580385 = validateParameter(valid_580385, JString, required = true,
                                 default = nil)
  if valid_580385 != nil:
    section.add "parent", valid_580385
  var valid_580386 = path.getOrDefault("location")
  valid_580386 = validateParameter(valid_580386, JString, required = true,
                                 default = nil)
  if valid_580386 != nil:
    section.add "location", valid_580386
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
  var valid_580387 = query.getOrDefault("upload_protocol")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "upload_protocol", valid_580387
  var valid_580388 = query.getOrDefault("fields")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "fields", valid_580388
  var valid_580389 = query.getOrDefault("quotaUser")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "quotaUser", valid_580389
  var valid_580390 = query.getOrDefault("alt")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = newJString("json"))
  if valid_580390 != nil:
    section.add "alt", valid_580390
  var valid_580391 = query.getOrDefault("oauth_token")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "oauth_token", valid_580391
  var valid_580392 = query.getOrDefault("callback")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "callback", valid_580392
  var valid_580393 = query.getOrDefault("access_token")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "access_token", valid_580393
  var valid_580394 = query.getOrDefault("uploadType")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "uploadType", valid_580394
  var valid_580395 = query.getOrDefault("key")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "key", valid_580395
  var valid_580396 = query.getOrDefault("$.xgafv")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = newJString("1"))
  if valid_580396 != nil:
    section.add "$.xgafv", valid_580396
  var valid_580397 = query.getOrDefault("prettyPrint")
  valid_580397 = validateParameter(valid_580397, JBool, required = false,
                                 default = newJBool(true))
  if valid_580397 != nil:
    section.add "prettyPrint", valid_580397
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

proc call*(call_580399: Call_DlpProjectsLocationsContentInspect_580382;
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
  let valid = call_580399.validator(path, query, header, formData, body)
  let scheme = call_580399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580399.url(scheme.get, call_580399.host, call_580399.base,
                         call_580399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580399, url, valid)

proc call*(call_580400: Call_DlpProjectsLocationsContentInspect_580382;
          parent: string; location: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The geographic location to process content inspection. Reserved for future
  ## extensions.
  var path_580401 = newJObject()
  var query_580402 = newJObject()
  var body_580403 = newJObject()
  add(query_580402, "upload_protocol", newJString(uploadProtocol))
  add(query_580402, "fields", newJString(fields))
  add(query_580402, "quotaUser", newJString(quotaUser))
  add(query_580402, "alt", newJString(alt))
  add(query_580402, "oauth_token", newJString(oauthToken))
  add(query_580402, "callback", newJString(callback))
  add(query_580402, "access_token", newJString(accessToken))
  add(query_580402, "uploadType", newJString(uploadType))
  add(path_580401, "parent", newJString(parent))
  add(query_580402, "key", newJString(key))
  add(query_580402, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580403 = body
  add(query_580402, "prettyPrint", newJBool(prettyPrint))
  add(path_580401, "location", newJString(location))
  result = call_580400.call(path_580401, query_580402, nil, nil, body_580403)

var dlpProjectsLocationsContentInspect* = Call_DlpProjectsLocationsContentInspect_580382(
    name: "dlpProjectsLocationsContentInspect", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com",
    route: "/v2/{parent}/locations/{location}/content:inspect",
    validator: validate_DlpProjectsLocationsContentInspect_580383, base: "/",
    url: url_DlpProjectsLocationsContentInspect_580384, schemes: {Scheme.Https})
type
  Call_DlpProjectsLocationsContentReidentify_580404 = ref object of OpenApiRestCall_579421
proc url_DlpProjectsLocationsContentReidentify_580406(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_DlpProjectsLocationsContentReidentify_580405(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name.
  ##   location: JString (required)
  ##           : The geographic location to process content reidentification.  Reserved for
  ## future extensions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580407 = path.getOrDefault("parent")
  valid_580407 = validateParameter(valid_580407, JString, required = true,
                                 default = nil)
  if valid_580407 != nil:
    section.add "parent", valid_580407
  var valid_580408 = path.getOrDefault("location")
  valid_580408 = validateParameter(valid_580408, JString, required = true,
                                 default = nil)
  if valid_580408 != nil:
    section.add "location", valid_580408
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
  var valid_580409 = query.getOrDefault("upload_protocol")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "upload_protocol", valid_580409
  var valid_580410 = query.getOrDefault("fields")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "fields", valid_580410
  var valid_580411 = query.getOrDefault("quotaUser")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "quotaUser", valid_580411
  var valid_580412 = query.getOrDefault("alt")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = newJString("json"))
  if valid_580412 != nil:
    section.add "alt", valid_580412
  var valid_580413 = query.getOrDefault("oauth_token")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "oauth_token", valid_580413
  var valid_580414 = query.getOrDefault("callback")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "callback", valid_580414
  var valid_580415 = query.getOrDefault("access_token")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "access_token", valid_580415
  var valid_580416 = query.getOrDefault("uploadType")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "uploadType", valid_580416
  var valid_580417 = query.getOrDefault("key")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "key", valid_580417
  var valid_580418 = query.getOrDefault("$.xgafv")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = newJString("1"))
  if valid_580418 != nil:
    section.add "$.xgafv", valid_580418
  var valid_580419 = query.getOrDefault("prettyPrint")
  valid_580419 = validateParameter(valid_580419, JBool, required = false,
                                 default = newJBool(true))
  if valid_580419 != nil:
    section.add "prettyPrint", valid_580419
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

proc call*(call_580421: Call_DlpProjectsLocationsContentReidentify_580404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
  ## 
  let valid = call_580421.validator(path, query, header, formData, body)
  let scheme = call_580421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580421.url(scheme.get, call_580421.host, call_580421.base,
                         call_580421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580421, url, valid)

proc call*(call_580422: Call_DlpProjectsLocationsContentReidentify_580404;
          parent: string; location: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dlpProjectsLocationsContentReidentify
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
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
  ##   parent: string (required)
  ##         : The parent resource name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The geographic location to process content reidentification.  Reserved for
  ## future extensions.
  var path_580423 = newJObject()
  var query_580424 = newJObject()
  var body_580425 = newJObject()
  add(query_580424, "upload_protocol", newJString(uploadProtocol))
  add(query_580424, "fields", newJString(fields))
  add(query_580424, "quotaUser", newJString(quotaUser))
  add(query_580424, "alt", newJString(alt))
  add(query_580424, "oauth_token", newJString(oauthToken))
  add(query_580424, "callback", newJString(callback))
  add(query_580424, "access_token", newJString(accessToken))
  add(query_580424, "uploadType", newJString(uploadType))
  add(path_580423, "parent", newJString(parent))
  add(query_580424, "key", newJString(key))
  add(query_580424, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580425 = body
  add(query_580424, "prettyPrint", newJBool(prettyPrint))
  add(path_580423, "location", newJString(location))
  result = call_580422.call(path_580423, query_580424, nil, nil, body_580425)

var dlpProjectsLocationsContentReidentify* = Call_DlpProjectsLocationsContentReidentify_580404(
    name: "dlpProjectsLocationsContentReidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com",
    route: "/v2/{parent}/locations/{location}/content:reidentify",
    validator: validate_DlpProjectsLocationsContentReidentify_580405, base: "/",
    url: url_DlpProjectsLocationsContentReidentify_580406, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsStoredInfoTypesCreate_580448 = ref object of OpenApiRestCall_579421
proc url_DlpOrganizationsStoredInfoTypesCreate_580450(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_DlpOrganizationsStoredInfoTypesCreate_580449(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a pre-built stored infoType to be used for inspection.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580451 = path.getOrDefault("parent")
  valid_580451 = validateParameter(valid_580451, JString, required = true,
                                 default = nil)
  if valid_580451 != nil:
    section.add "parent", valid_580451
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
  var valid_580452 = query.getOrDefault("upload_protocol")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "upload_protocol", valid_580452
  var valid_580453 = query.getOrDefault("fields")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "fields", valid_580453
  var valid_580454 = query.getOrDefault("quotaUser")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "quotaUser", valid_580454
  var valid_580455 = query.getOrDefault("alt")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = newJString("json"))
  if valid_580455 != nil:
    section.add "alt", valid_580455
  var valid_580456 = query.getOrDefault("oauth_token")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "oauth_token", valid_580456
  var valid_580457 = query.getOrDefault("callback")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = nil)
  if valid_580457 != nil:
    section.add "callback", valid_580457
  var valid_580458 = query.getOrDefault("access_token")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = nil)
  if valid_580458 != nil:
    section.add "access_token", valid_580458
  var valid_580459 = query.getOrDefault("uploadType")
  valid_580459 = validateParameter(valid_580459, JString, required = false,
                                 default = nil)
  if valid_580459 != nil:
    section.add "uploadType", valid_580459
  var valid_580460 = query.getOrDefault("key")
  valid_580460 = validateParameter(valid_580460, JString, required = false,
                                 default = nil)
  if valid_580460 != nil:
    section.add "key", valid_580460
  var valid_580461 = query.getOrDefault("$.xgafv")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = newJString("1"))
  if valid_580461 != nil:
    section.add "$.xgafv", valid_580461
  var valid_580462 = query.getOrDefault("prettyPrint")
  valid_580462 = validateParameter(valid_580462, JBool, required = false,
                                 default = newJBool(true))
  if valid_580462 != nil:
    section.add "prettyPrint", valid_580462
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

proc call*(call_580464: Call_DlpOrganizationsStoredInfoTypesCreate_580448;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a pre-built stored infoType to be used for inspection.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  let valid = call_580464.validator(path, query, header, formData, body)
  let scheme = call_580464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580464.url(scheme.get, call_580464.host, call_580464.base,
                         call_580464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580464, url, valid)

proc call*(call_580465: Call_DlpOrganizationsStoredInfoTypesCreate_580448;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dlpOrganizationsStoredInfoTypesCreate
  ## Creates a pre-built stored infoType to be used for inspection.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
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
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580466 = newJObject()
  var query_580467 = newJObject()
  var body_580468 = newJObject()
  add(query_580467, "upload_protocol", newJString(uploadProtocol))
  add(query_580467, "fields", newJString(fields))
  add(query_580467, "quotaUser", newJString(quotaUser))
  add(query_580467, "alt", newJString(alt))
  add(query_580467, "oauth_token", newJString(oauthToken))
  add(query_580467, "callback", newJString(callback))
  add(query_580467, "access_token", newJString(accessToken))
  add(query_580467, "uploadType", newJString(uploadType))
  add(path_580466, "parent", newJString(parent))
  add(query_580467, "key", newJString(key))
  add(query_580467, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580468 = body
  add(query_580467, "prettyPrint", newJBool(prettyPrint))
  result = call_580465.call(path_580466, query_580467, nil, nil, body_580468)

var dlpOrganizationsStoredInfoTypesCreate* = Call_DlpOrganizationsStoredInfoTypesCreate_580448(
    name: "dlpOrganizationsStoredInfoTypesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/storedInfoTypes",
    validator: validate_DlpOrganizationsStoredInfoTypesCreate_580449, base: "/",
    url: url_DlpOrganizationsStoredInfoTypesCreate_580450, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsStoredInfoTypesList_580426 = ref object of OpenApiRestCall_579421
proc url_DlpOrganizationsStoredInfoTypesList_580428(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DlpOrganizationsStoredInfoTypesList_580427(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists stored infoTypes.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580429 = path.getOrDefault("parent")
  valid_580429 = validateParameter(valid_580429, JString, required = true,
                                 default = nil)
  if valid_580429 != nil:
    section.add "parent", valid_580429
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListStoredInfoTypes`.
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580430 = query.getOrDefault("upload_protocol")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "upload_protocol", valid_580430
  var valid_580431 = query.getOrDefault("fields")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "fields", valid_580431
  var valid_580432 = query.getOrDefault("pageToken")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "pageToken", valid_580432
  var valid_580433 = query.getOrDefault("quotaUser")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "quotaUser", valid_580433
  var valid_580434 = query.getOrDefault("alt")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = newJString("json"))
  if valid_580434 != nil:
    section.add "alt", valid_580434
  var valid_580435 = query.getOrDefault("oauth_token")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "oauth_token", valid_580435
  var valid_580436 = query.getOrDefault("callback")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "callback", valid_580436
  var valid_580437 = query.getOrDefault("access_token")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "access_token", valid_580437
  var valid_580438 = query.getOrDefault("uploadType")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "uploadType", valid_580438
  var valid_580439 = query.getOrDefault("orderBy")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "orderBy", valid_580439
  var valid_580440 = query.getOrDefault("key")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "key", valid_580440
  var valid_580441 = query.getOrDefault("$.xgafv")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = newJString("1"))
  if valid_580441 != nil:
    section.add "$.xgafv", valid_580441
  var valid_580442 = query.getOrDefault("pageSize")
  valid_580442 = validateParameter(valid_580442, JInt, required = false, default = nil)
  if valid_580442 != nil:
    section.add "pageSize", valid_580442
  var valid_580443 = query.getOrDefault("prettyPrint")
  valid_580443 = validateParameter(valid_580443, JBool, required = false,
                                 default = newJBool(true))
  if valid_580443 != nil:
    section.add "prettyPrint", valid_580443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580444: Call_DlpOrganizationsStoredInfoTypesList_580426;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists stored infoTypes.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  let valid = call_580444.validator(path, query, header, formData, body)
  let scheme = call_580444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580444.url(scheme.get, call_580444.host, call_580444.base,
                         call_580444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580444, url, valid)

proc call*(call_580445: Call_DlpOrganizationsStoredInfoTypesList_580426;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## dlpOrganizationsStoredInfoTypesList
  ## Lists stored infoTypes.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to `ListStoredInfoTypes`.
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
  ##   parent: string (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580446 = newJObject()
  var query_580447 = newJObject()
  add(query_580447, "upload_protocol", newJString(uploadProtocol))
  add(query_580447, "fields", newJString(fields))
  add(query_580447, "pageToken", newJString(pageToken))
  add(query_580447, "quotaUser", newJString(quotaUser))
  add(query_580447, "alt", newJString(alt))
  add(query_580447, "oauth_token", newJString(oauthToken))
  add(query_580447, "callback", newJString(callback))
  add(query_580447, "access_token", newJString(accessToken))
  add(query_580447, "uploadType", newJString(uploadType))
  add(path_580446, "parent", newJString(parent))
  add(query_580447, "orderBy", newJString(orderBy))
  add(query_580447, "key", newJString(key))
  add(query_580447, "$.xgafv", newJString(Xgafv))
  add(query_580447, "pageSize", newJInt(pageSize))
  add(query_580447, "prettyPrint", newJBool(prettyPrint))
  result = call_580445.call(path_580446, query_580447, nil, nil, nil)

var dlpOrganizationsStoredInfoTypesList* = Call_DlpOrganizationsStoredInfoTypesList_580426(
    name: "dlpOrganizationsStoredInfoTypesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/storedInfoTypes",
    validator: validate_DlpOrganizationsStoredInfoTypesList_580427, base: "/",
    url: url_DlpOrganizationsStoredInfoTypesList_580428, schemes: {Scheme.Https})
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
