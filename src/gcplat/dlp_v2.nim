
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DlpInfoTypesList_593690 = ref object of OpenApiRestCall_593421
proc url_DlpInfoTypesList_593692(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DlpInfoTypesList_593691(path: JsonNode; query: JsonNode;
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
  var valid_593804 = query.getOrDefault("upload_protocol")
  valid_593804 = validateParameter(valid_593804, JString, required = false,
                                 default = nil)
  if valid_593804 != nil:
    section.add "upload_protocol", valid_593804
  var valid_593805 = query.getOrDefault("fields")
  valid_593805 = validateParameter(valid_593805, JString, required = false,
                                 default = nil)
  if valid_593805 != nil:
    section.add "fields", valid_593805
  var valid_593806 = query.getOrDefault("quotaUser")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "quotaUser", valid_593806
  var valid_593820 = query.getOrDefault("alt")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = newJString("json"))
  if valid_593820 != nil:
    section.add "alt", valid_593820
  var valid_593821 = query.getOrDefault("oauth_token")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "oauth_token", valid_593821
  var valid_593822 = query.getOrDefault("callback")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "callback", valid_593822
  var valid_593823 = query.getOrDefault("access_token")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "access_token", valid_593823
  var valid_593824 = query.getOrDefault("uploadType")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "uploadType", valid_593824
  var valid_593825 = query.getOrDefault("location")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "location", valid_593825
  var valid_593826 = query.getOrDefault("key")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "key", valid_593826
  var valid_593827 = query.getOrDefault("$.xgafv")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = newJString("1"))
  if valid_593827 != nil:
    section.add "$.xgafv", valid_593827
  var valid_593828 = query.getOrDefault("languageCode")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = nil)
  if valid_593828 != nil:
    section.add "languageCode", valid_593828
  var valid_593829 = query.getOrDefault("prettyPrint")
  valid_593829 = validateParameter(valid_593829, JBool, required = false,
                                 default = newJBool(true))
  if valid_593829 != nil:
    section.add "prettyPrint", valid_593829
  var valid_593830 = query.getOrDefault("filter")
  valid_593830 = validateParameter(valid_593830, JString, required = false,
                                 default = nil)
  if valid_593830 != nil:
    section.add "filter", valid_593830
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593853: Call_DlpInfoTypesList_593690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
  ## 
  let valid = call_593853.validator(path, query, header, formData, body)
  let scheme = call_593853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593853.url(scheme.get, call_593853.host, call_593853.base,
                         call_593853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593853, url, valid)

proc call*(call_593924: Call_DlpInfoTypesList_593690; uploadProtocol: string = "";
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
  var query_593925 = newJObject()
  add(query_593925, "upload_protocol", newJString(uploadProtocol))
  add(query_593925, "fields", newJString(fields))
  add(query_593925, "quotaUser", newJString(quotaUser))
  add(query_593925, "alt", newJString(alt))
  add(query_593925, "oauth_token", newJString(oauthToken))
  add(query_593925, "callback", newJString(callback))
  add(query_593925, "access_token", newJString(accessToken))
  add(query_593925, "uploadType", newJString(uploadType))
  add(query_593925, "location", newJString(location))
  add(query_593925, "key", newJString(key))
  add(query_593925, "$.xgafv", newJString(Xgafv))
  add(query_593925, "languageCode", newJString(languageCode))
  add(query_593925, "prettyPrint", newJBool(prettyPrint))
  add(query_593925, "filter", newJString(filter))
  result = call_593924.call(nil, query_593925, nil, nil, nil)

var dlpInfoTypesList* = Call_DlpInfoTypesList_593690(name: "dlpInfoTypesList",
    meth: HttpMethod.HttpGet, host: "dlp.googleapis.com", route: "/v2/infoTypes",
    validator: validate_DlpInfoTypesList_593691, base: "/",
    url: url_DlpInfoTypesList_593692, schemes: {Scheme.Https})
type
  Call_DlpLocationsInfoTypes_593965 = ref object of OpenApiRestCall_593421
proc url_DlpLocationsInfoTypes_593967(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpLocationsInfoTypes_593966(path: JsonNode; query: JsonNode;
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
  var valid_593982 = path.getOrDefault("location")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "location", valid_593982
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
  var valid_593983 = query.getOrDefault("upload_protocol")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "upload_protocol", valid_593983
  var valid_593984 = query.getOrDefault("fields")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "fields", valid_593984
  var valid_593985 = query.getOrDefault("quotaUser")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "quotaUser", valid_593985
  var valid_593986 = query.getOrDefault("alt")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = newJString("json"))
  if valid_593986 != nil:
    section.add "alt", valid_593986
  var valid_593987 = query.getOrDefault("oauth_token")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "oauth_token", valid_593987
  var valid_593988 = query.getOrDefault("callback")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "callback", valid_593988
  var valid_593989 = query.getOrDefault("access_token")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "access_token", valid_593989
  var valid_593990 = query.getOrDefault("uploadType")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "uploadType", valid_593990
  var valid_593991 = query.getOrDefault("key")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "key", valid_593991
  var valid_593992 = query.getOrDefault("$.xgafv")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = newJString("1"))
  if valid_593992 != nil:
    section.add "$.xgafv", valid_593992
  var valid_593993 = query.getOrDefault("prettyPrint")
  valid_593993 = validateParameter(valid_593993, JBool, required = false,
                                 default = newJBool(true))
  if valid_593993 != nil:
    section.add "prettyPrint", valid_593993
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

proc call*(call_593995: Call_DlpLocationsInfoTypes_593965; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of the sensitive information types that the DLP API
  ## supports. See https://cloud.google.com/dlp/docs/infotypes-reference to
  ## learn more.
  ## 
  let valid = call_593995.validator(path, query, header, formData, body)
  let scheme = call_593995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593995.url(scheme.get, call_593995.host, call_593995.base,
                         call_593995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593995, url, valid)

proc call*(call_593996: Call_DlpLocationsInfoTypes_593965; location: string;
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
  var path_593997 = newJObject()
  var query_593998 = newJObject()
  var body_593999 = newJObject()
  add(query_593998, "upload_protocol", newJString(uploadProtocol))
  add(query_593998, "fields", newJString(fields))
  add(query_593998, "quotaUser", newJString(quotaUser))
  add(query_593998, "alt", newJString(alt))
  add(query_593998, "oauth_token", newJString(oauthToken))
  add(query_593998, "callback", newJString(callback))
  add(query_593998, "access_token", newJString(accessToken))
  add(query_593998, "uploadType", newJString(uploadType))
  add(query_593998, "key", newJString(key))
  add(query_593998, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593999 = body
  add(query_593998, "prettyPrint", newJBool(prettyPrint))
  add(path_593997, "location", newJString(location))
  result = call_593996.call(path_593997, query_593998, nil, nil, body_593999)

var dlpLocationsInfoTypes* = Call_DlpLocationsInfoTypes_593965(
    name: "dlpLocationsInfoTypes", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/locations/{location}/infoTypes",
    validator: validate_DlpLocationsInfoTypes_593966, base: "/",
    url: url_DlpLocationsInfoTypes_593967, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsStoredInfoTypesGet_594000 = ref object of OpenApiRestCall_593421
proc url_DlpOrganizationsStoredInfoTypesGet_594002(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpOrganizationsStoredInfoTypesGet_594001(path: JsonNode;
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
  var valid_594003 = path.getOrDefault("name")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "name", valid_594003
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
  var valid_594004 = query.getOrDefault("upload_protocol")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "upload_protocol", valid_594004
  var valid_594005 = query.getOrDefault("fields")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "fields", valid_594005
  var valid_594006 = query.getOrDefault("quotaUser")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "quotaUser", valid_594006
  var valid_594007 = query.getOrDefault("alt")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = newJString("json"))
  if valid_594007 != nil:
    section.add "alt", valid_594007
  var valid_594008 = query.getOrDefault("oauth_token")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "oauth_token", valid_594008
  var valid_594009 = query.getOrDefault("callback")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "callback", valid_594009
  var valid_594010 = query.getOrDefault("access_token")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "access_token", valid_594010
  var valid_594011 = query.getOrDefault("uploadType")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "uploadType", valid_594011
  var valid_594012 = query.getOrDefault("key")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "key", valid_594012
  var valid_594013 = query.getOrDefault("$.xgafv")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = newJString("1"))
  if valid_594013 != nil:
    section.add "$.xgafv", valid_594013
  var valid_594014 = query.getOrDefault("prettyPrint")
  valid_594014 = validateParameter(valid_594014, JBool, required = false,
                                 default = newJBool(true))
  if valid_594014 != nil:
    section.add "prettyPrint", valid_594014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_DlpOrganizationsStoredInfoTypesGet_594000;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a stored infoType.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_DlpOrganizationsStoredInfoTypesGet_594000;
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
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  add(query_594018, "upload_protocol", newJString(uploadProtocol))
  add(query_594018, "fields", newJString(fields))
  add(query_594018, "quotaUser", newJString(quotaUser))
  add(path_594017, "name", newJString(name))
  add(query_594018, "alt", newJString(alt))
  add(query_594018, "oauth_token", newJString(oauthToken))
  add(query_594018, "callback", newJString(callback))
  add(query_594018, "access_token", newJString(accessToken))
  add(query_594018, "uploadType", newJString(uploadType))
  add(query_594018, "key", newJString(key))
  add(query_594018, "$.xgafv", newJString(Xgafv))
  add(query_594018, "prettyPrint", newJBool(prettyPrint))
  result = call_594016.call(path_594017, query_594018, nil, nil, nil)

var dlpOrganizationsStoredInfoTypesGet* = Call_DlpOrganizationsStoredInfoTypesGet_594000(
    name: "dlpOrganizationsStoredInfoTypesGet", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{name}",
    validator: validate_DlpOrganizationsStoredInfoTypesGet_594001, base: "/",
    url: url_DlpOrganizationsStoredInfoTypesGet_594002, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsStoredInfoTypesPatch_594038 = ref object of OpenApiRestCall_593421
proc url_DlpOrganizationsStoredInfoTypesPatch_594040(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpOrganizationsStoredInfoTypesPatch_594039(path: JsonNode;
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
  var valid_594041 = path.getOrDefault("name")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "name", valid_594041
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
  var valid_594042 = query.getOrDefault("upload_protocol")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "upload_protocol", valid_594042
  var valid_594043 = query.getOrDefault("fields")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "fields", valid_594043
  var valid_594044 = query.getOrDefault("quotaUser")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "quotaUser", valid_594044
  var valid_594045 = query.getOrDefault("alt")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = newJString("json"))
  if valid_594045 != nil:
    section.add "alt", valid_594045
  var valid_594046 = query.getOrDefault("oauth_token")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "oauth_token", valid_594046
  var valid_594047 = query.getOrDefault("callback")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "callback", valid_594047
  var valid_594048 = query.getOrDefault("access_token")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "access_token", valid_594048
  var valid_594049 = query.getOrDefault("uploadType")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "uploadType", valid_594049
  var valid_594050 = query.getOrDefault("key")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "key", valid_594050
  var valid_594051 = query.getOrDefault("$.xgafv")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = newJString("1"))
  if valid_594051 != nil:
    section.add "$.xgafv", valid_594051
  var valid_594052 = query.getOrDefault("prettyPrint")
  valid_594052 = validateParameter(valid_594052, JBool, required = false,
                                 default = newJBool(true))
  if valid_594052 != nil:
    section.add "prettyPrint", valid_594052
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

proc call*(call_594054: Call_DlpOrganizationsStoredInfoTypesPatch_594038;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the stored infoType by creating a new version. The existing version
  ## will continue to be used until the new version is ready.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  let valid = call_594054.validator(path, query, header, formData, body)
  let scheme = call_594054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594054.url(scheme.get, call_594054.host, call_594054.base,
                         call_594054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594054, url, valid)

proc call*(call_594055: Call_DlpOrganizationsStoredInfoTypesPatch_594038;
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
  var path_594056 = newJObject()
  var query_594057 = newJObject()
  var body_594058 = newJObject()
  add(query_594057, "upload_protocol", newJString(uploadProtocol))
  add(query_594057, "fields", newJString(fields))
  add(query_594057, "quotaUser", newJString(quotaUser))
  add(path_594056, "name", newJString(name))
  add(query_594057, "alt", newJString(alt))
  add(query_594057, "oauth_token", newJString(oauthToken))
  add(query_594057, "callback", newJString(callback))
  add(query_594057, "access_token", newJString(accessToken))
  add(query_594057, "uploadType", newJString(uploadType))
  add(query_594057, "key", newJString(key))
  add(query_594057, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594058 = body
  add(query_594057, "prettyPrint", newJBool(prettyPrint))
  result = call_594055.call(path_594056, query_594057, nil, nil, body_594058)

var dlpOrganizationsStoredInfoTypesPatch* = Call_DlpOrganizationsStoredInfoTypesPatch_594038(
    name: "dlpOrganizationsStoredInfoTypesPatch", meth: HttpMethod.HttpPatch,
    host: "dlp.googleapis.com", route: "/v2/{name}",
    validator: validate_DlpOrganizationsStoredInfoTypesPatch_594039, base: "/",
    url: url_DlpOrganizationsStoredInfoTypesPatch_594040, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsStoredInfoTypesDelete_594019 = ref object of OpenApiRestCall_593421
proc url_DlpOrganizationsStoredInfoTypesDelete_594021(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpOrganizationsStoredInfoTypesDelete_594020(path: JsonNode;
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
  var valid_594022 = path.getOrDefault("name")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "name", valid_594022
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
  var valid_594023 = query.getOrDefault("upload_protocol")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "upload_protocol", valid_594023
  var valid_594024 = query.getOrDefault("fields")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "fields", valid_594024
  var valid_594025 = query.getOrDefault("quotaUser")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "quotaUser", valid_594025
  var valid_594026 = query.getOrDefault("alt")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = newJString("json"))
  if valid_594026 != nil:
    section.add "alt", valid_594026
  var valid_594027 = query.getOrDefault("oauth_token")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "oauth_token", valid_594027
  var valid_594028 = query.getOrDefault("callback")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "callback", valid_594028
  var valid_594029 = query.getOrDefault("access_token")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "access_token", valid_594029
  var valid_594030 = query.getOrDefault("uploadType")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "uploadType", valid_594030
  var valid_594031 = query.getOrDefault("key")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "key", valid_594031
  var valid_594032 = query.getOrDefault("$.xgafv")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = newJString("1"))
  if valid_594032 != nil:
    section.add "$.xgafv", valid_594032
  var valid_594033 = query.getOrDefault("prettyPrint")
  valid_594033 = validateParameter(valid_594033, JBool, required = false,
                                 default = newJBool(true))
  if valid_594033 != nil:
    section.add "prettyPrint", valid_594033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594034: Call_DlpOrganizationsStoredInfoTypesDelete_594019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a stored infoType.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  let valid = call_594034.validator(path, query, header, formData, body)
  let scheme = call_594034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594034.url(scheme.get, call_594034.host, call_594034.base,
                         call_594034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594034, url, valid)

proc call*(call_594035: Call_DlpOrganizationsStoredInfoTypesDelete_594019;
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
  var path_594036 = newJObject()
  var query_594037 = newJObject()
  add(query_594037, "upload_protocol", newJString(uploadProtocol))
  add(query_594037, "fields", newJString(fields))
  add(query_594037, "quotaUser", newJString(quotaUser))
  add(path_594036, "name", newJString(name))
  add(query_594037, "alt", newJString(alt))
  add(query_594037, "oauth_token", newJString(oauthToken))
  add(query_594037, "callback", newJString(callback))
  add(query_594037, "access_token", newJString(accessToken))
  add(query_594037, "uploadType", newJString(uploadType))
  add(query_594037, "key", newJString(key))
  add(query_594037, "$.xgafv", newJString(Xgafv))
  add(query_594037, "prettyPrint", newJBool(prettyPrint))
  result = call_594035.call(path_594036, query_594037, nil, nil, nil)

var dlpOrganizationsStoredInfoTypesDelete* = Call_DlpOrganizationsStoredInfoTypesDelete_594019(
    name: "dlpOrganizationsStoredInfoTypesDelete", meth: HttpMethod.HttpDelete,
    host: "dlp.googleapis.com", route: "/v2/{name}",
    validator: validate_DlpOrganizationsStoredInfoTypesDelete_594020, base: "/",
    url: url_DlpOrganizationsStoredInfoTypesDelete_594021, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersActivate_594059 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsJobTriggersActivate_594061(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpProjectsJobTriggersActivate_594060(path: JsonNode;
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
  var valid_594062 = path.getOrDefault("name")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "name", valid_594062
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
  var valid_594063 = query.getOrDefault("upload_protocol")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "upload_protocol", valid_594063
  var valid_594064 = query.getOrDefault("fields")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "fields", valid_594064
  var valid_594065 = query.getOrDefault("quotaUser")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "quotaUser", valid_594065
  var valid_594066 = query.getOrDefault("alt")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = newJString("json"))
  if valid_594066 != nil:
    section.add "alt", valid_594066
  var valid_594067 = query.getOrDefault("oauth_token")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "oauth_token", valid_594067
  var valid_594068 = query.getOrDefault("callback")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "callback", valid_594068
  var valid_594069 = query.getOrDefault("access_token")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "access_token", valid_594069
  var valid_594070 = query.getOrDefault("uploadType")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "uploadType", valid_594070
  var valid_594071 = query.getOrDefault("key")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "key", valid_594071
  var valid_594072 = query.getOrDefault("$.xgafv")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = newJString("1"))
  if valid_594072 != nil:
    section.add "$.xgafv", valid_594072
  var valid_594073 = query.getOrDefault("prettyPrint")
  valid_594073 = validateParameter(valid_594073, JBool, required = false,
                                 default = newJBool(true))
  if valid_594073 != nil:
    section.add "prettyPrint", valid_594073
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

proc call*(call_594075: Call_DlpProjectsJobTriggersActivate_594059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activate a job trigger. Causes the immediate execute of a trigger
  ## instead of waiting on the trigger event to occur.
  ## 
  let valid = call_594075.validator(path, query, header, formData, body)
  let scheme = call_594075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594075.url(scheme.get, call_594075.host, call_594075.base,
                         call_594075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594075, url, valid)

proc call*(call_594076: Call_DlpProjectsJobTriggersActivate_594059; name: string;
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
  var path_594077 = newJObject()
  var query_594078 = newJObject()
  var body_594079 = newJObject()
  add(query_594078, "upload_protocol", newJString(uploadProtocol))
  add(query_594078, "fields", newJString(fields))
  add(query_594078, "quotaUser", newJString(quotaUser))
  add(path_594077, "name", newJString(name))
  add(query_594078, "alt", newJString(alt))
  add(query_594078, "oauth_token", newJString(oauthToken))
  add(query_594078, "callback", newJString(callback))
  add(query_594078, "access_token", newJString(accessToken))
  add(query_594078, "uploadType", newJString(uploadType))
  add(query_594078, "key", newJString(key))
  add(query_594078, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594079 = body
  add(query_594078, "prettyPrint", newJBool(prettyPrint))
  result = call_594076.call(path_594077, query_594078, nil, nil, body_594079)

var dlpProjectsJobTriggersActivate* = Call_DlpProjectsJobTriggersActivate_594059(
    name: "dlpProjectsJobTriggersActivate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{name}:activate",
    validator: validate_DlpProjectsJobTriggersActivate_594060, base: "/",
    url: url_DlpProjectsJobTriggersActivate_594061, schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsCancel_594080 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsDlpJobsCancel_594082(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpProjectsDlpJobsCancel_594081(path: JsonNode; query: JsonNode;
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
  var valid_594083 = path.getOrDefault("name")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "name", valid_594083
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
  var valid_594084 = query.getOrDefault("upload_protocol")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "upload_protocol", valid_594084
  var valid_594085 = query.getOrDefault("fields")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "fields", valid_594085
  var valid_594086 = query.getOrDefault("quotaUser")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "quotaUser", valid_594086
  var valid_594087 = query.getOrDefault("alt")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = newJString("json"))
  if valid_594087 != nil:
    section.add "alt", valid_594087
  var valid_594088 = query.getOrDefault("oauth_token")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "oauth_token", valid_594088
  var valid_594089 = query.getOrDefault("callback")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "callback", valid_594089
  var valid_594090 = query.getOrDefault("access_token")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "access_token", valid_594090
  var valid_594091 = query.getOrDefault("uploadType")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "uploadType", valid_594091
  var valid_594092 = query.getOrDefault("key")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "key", valid_594092
  var valid_594093 = query.getOrDefault("$.xgafv")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = newJString("1"))
  if valid_594093 != nil:
    section.add "$.xgafv", valid_594093
  var valid_594094 = query.getOrDefault("prettyPrint")
  valid_594094 = validateParameter(valid_594094, JBool, required = false,
                                 default = newJBool(true))
  if valid_594094 != nil:
    section.add "prettyPrint", valid_594094
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

proc call*(call_594096: Call_DlpProjectsDlpJobsCancel_594080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running DlpJob. The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  let valid = call_594096.validator(path, query, header, formData, body)
  let scheme = call_594096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594096.url(scheme.get, call_594096.host, call_594096.base,
                         call_594096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594096, url, valid)

proc call*(call_594097: Call_DlpProjectsDlpJobsCancel_594080; name: string;
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
  var path_594098 = newJObject()
  var query_594099 = newJObject()
  var body_594100 = newJObject()
  add(query_594099, "upload_protocol", newJString(uploadProtocol))
  add(query_594099, "fields", newJString(fields))
  add(query_594099, "quotaUser", newJString(quotaUser))
  add(path_594098, "name", newJString(name))
  add(query_594099, "alt", newJString(alt))
  add(query_594099, "oauth_token", newJString(oauthToken))
  add(query_594099, "callback", newJString(callback))
  add(query_594099, "access_token", newJString(accessToken))
  add(query_594099, "uploadType", newJString(uploadType))
  add(query_594099, "key", newJString(key))
  add(query_594099, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594100 = body
  add(query_594099, "prettyPrint", newJBool(prettyPrint))
  result = call_594097.call(path_594098, query_594099, nil, nil, body_594100)

var dlpProjectsDlpJobsCancel* = Call_DlpProjectsDlpJobsCancel_594080(
    name: "dlpProjectsDlpJobsCancel", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{name}:cancel",
    validator: validate_DlpProjectsDlpJobsCancel_594081, base: "/",
    url: url_DlpProjectsDlpJobsCancel_594082, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentDeidentify_594101 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsContentDeidentify_594103(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpProjectsContentDeidentify_594102(path: JsonNode; query: JsonNode;
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
  var valid_594104 = path.getOrDefault("parent")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "parent", valid_594104
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
  var valid_594105 = query.getOrDefault("upload_protocol")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "upload_protocol", valid_594105
  var valid_594106 = query.getOrDefault("fields")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "fields", valid_594106
  var valid_594107 = query.getOrDefault("quotaUser")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "quotaUser", valid_594107
  var valid_594108 = query.getOrDefault("alt")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = newJString("json"))
  if valid_594108 != nil:
    section.add "alt", valid_594108
  var valid_594109 = query.getOrDefault("oauth_token")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "oauth_token", valid_594109
  var valid_594110 = query.getOrDefault("callback")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "callback", valid_594110
  var valid_594111 = query.getOrDefault("access_token")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "access_token", valid_594111
  var valid_594112 = query.getOrDefault("uploadType")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "uploadType", valid_594112
  var valid_594113 = query.getOrDefault("key")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "key", valid_594113
  var valid_594114 = query.getOrDefault("$.xgafv")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = newJString("1"))
  if valid_594114 != nil:
    section.add "$.xgafv", valid_594114
  var valid_594115 = query.getOrDefault("prettyPrint")
  valid_594115 = validateParameter(valid_594115, JBool, required = false,
                                 default = newJBool(true))
  if valid_594115 != nil:
    section.add "prettyPrint", valid_594115
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

proc call*(call_594117: Call_DlpProjectsContentDeidentify_594101; path: JsonNode;
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
  let valid = call_594117.validator(path, query, header, formData, body)
  let scheme = call_594117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594117.url(scheme.get, call_594117.host, call_594117.base,
                         call_594117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594117, url, valid)

proc call*(call_594118: Call_DlpProjectsContentDeidentify_594101; parent: string;
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
  var path_594119 = newJObject()
  var query_594120 = newJObject()
  var body_594121 = newJObject()
  add(query_594120, "upload_protocol", newJString(uploadProtocol))
  add(query_594120, "fields", newJString(fields))
  add(query_594120, "quotaUser", newJString(quotaUser))
  add(query_594120, "alt", newJString(alt))
  add(query_594120, "oauth_token", newJString(oauthToken))
  add(query_594120, "callback", newJString(callback))
  add(query_594120, "access_token", newJString(accessToken))
  add(query_594120, "uploadType", newJString(uploadType))
  add(path_594119, "parent", newJString(parent))
  add(query_594120, "key", newJString(key))
  add(query_594120, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594121 = body
  add(query_594120, "prettyPrint", newJBool(prettyPrint))
  result = call_594118.call(path_594119, query_594120, nil, nil, body_594121)

var dlpProjectsContentDeidentify* = Call_DlpProjectsContentDeidentify_594101(
    name: "dlpProjectsContentDeidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/content:deidentify",
    validator: validate_DlpProjectsContentDeidentify_594102, base: "/",
    url: url_DlpProjectsContentDeidentify_594103, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentInspect_594122 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsContentInspect_594124(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpProjectsContentInspect_594123(path: JsonNode; query: JsonNode;
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
  var valid_594125 = path.getOrDefault("parent")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "parent", valid_594125
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
  var valid_594126 = query.getOrDefault("upload_protocol")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "upload_protocol", valid_594126
  var valid_594127 = query.getOrDefault("fields")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "fields", valid_594127
  var valid_594128 = query.getOrDefault("quotaUser")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "quotaUser", valid_594128
  var valid_594129 = query.getOrDefault("alt")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = newJString("json"))
  if valid_594129 != nil:
    section.add "alt", valid_594129
  var valid_594130 = query.getOrDefault("oauth_token")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "oauth_token", valid_594130
  var valid_594131 = query.getOrDefault("callback")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "callback", valid_594131
  var valid_594132 = query.getOrDefault("access_token")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "access_token", valid_594132
  var valid_594133 = query.getOrDefault("uploadType")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "uploadType", valid_594133
  var valid_594134 = query.getOrDefault("key")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "key", valid_594134
  var valid_594135 = query.getOrDefault("$.xgafv")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = newJString("1"))
  if valid_594135 != nil:
    section.add "$.xgafv", valid_594135
  var valid_594136 = query.getOrDefault("prettyPrint")
  valid_594136 = validateParameter(valid_594136, JBool, required = false,
                                 default = newJBool(true))
  if valid_594136 != nil:
    section.add "prettyPrint", valid_594136
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

proc call*(call_594138: Call_DlpProjectsContentInspect_594122; path: JsonNode;
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
  let valid = call_594138.validator(path, query, header, formData, body)
  let scheme = call_594138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594138.url(scheme.get, call_594138.host, call_594138.base,
                         call_594138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594138, url, valid)

proc call*(call_594139: Call_DlpProjectsContentInspect_594122; parent: string;
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
  var path_594140 = newJObject()
  var query_594141 = newJObject()
  var body_594142 = newJObject()
  add(query_594141, "upload_protocol", newJString(uploadProtocol))
  add(query_594141, "fields", newJString(fields))
  add(query_594141, "quotaUser", newJString(quotaUser))
  add(query_594141, "alt", newJString(alt))
  add(query_594141, "oauth_token", newJString(oauthToken))
  add(query_594141, "callback", newJString(callback))
  add(query_594141, "access_token", newJString(accessToken))
  add(query_594141, "uploadType", newJString(uploadType))
  add(path_594140, "parent", newJString(parent))
  add(query_594141, "key", newJString(key))
  add(query_594141, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594142 = body
  add(query_594141, "prettyPrint", newJBool(prettyPrint))
  result = call_594139.call(path_594140, query_594141, nil, nil, body_594142)

var dlpProjectsContentInspect* = Call_DlpProjectsContentInspect_594122(
    name: "dlpProjectsContentInspect", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/content:inspect",
    validator: validate_DlpProjectsContentInspect_594123, base: "/",
    url: url_DlpProjectsContentInspect_594124, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentReidentify_594143 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsContentReidentify_594145(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpProjectsContentReidentify_594144(path: JsonNode; query: JsonNode;
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
  var valid_594146 = path.getOrDefault("parent")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "parent", valid_594146
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
  var valid_594147 = query.getOrDefault("upload_protocol")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "upload_protocol", valid_594147
  var valid_594148 = query.getOrDefault("fields")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "fields", valid_594148
  var valid_594149 = query.getOrDefault("quotaUser")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "quotaUser", valid_594149
  var valid_594150 = query.getOrDefault("alt")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = newJString("json"))
  if valid_594150 != nil:
    section.add "alt", valid_594150
  var valid_594151 = query.getOrDefault("oauth_token")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "oauth_token", valid_594151
  var valid_594152 = query.getOrDefault("callback")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "callback", valid_594152
  var valid_594153 = query.getOrDefault("access_token")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "access_token", valid_594153
  var valid_594154 = query.getOrDefault("uploadType")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "uploadType", valid_594154
  var valid_594155 = query.getOrDefault("key")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "key", valid_594155
  var valid_594156 = query.getOrDefault("$.xgafv")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = newJString("1"))
  if valid_594156 != nil:
    section.add "$.xgafv", valid_594156
  var valid_594157 = query.getOrDefault("prettyPrint")
  valid_594157 = validateParameter(valid_594157, JBool, required = false,
                                 default = newJBool(true))
  if valid_594157 != nil:
    section.add "prettyPrint", valid_594157
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

proc call*(call_594159: Call_DlpProjectsContentReidentify_594143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
  ## 
  let valid = call_594159.validator(path, query, header, formData, body)
  let scheme = call_594159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594159.url(scheme.get, call_594159.host, call_594159.base,
                         call_594159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594159, url, valid)

proc call*(call_594160: Call_DlpProjectsContentReidentify_594143; parent: string;
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
  var path_594161 = newJObject()
  var query_594162 = newJObject()
  var body_594163 = newJObject()
  add(query_594162, "upload_protocol", newJString(uploadProtocol))
  add(query_594162, "fields", newJString(fields))
  add(query_594162, "quotaUser", newJString(quotaUser))
  add(query_594162, "alt", newJString(alt))
  add(query_594162, "oauth_token", newJString(oauthToken))
  add(query_594162, "callback", newJString(callback))
  add(query_594162, "access_token", newJString(accessToken))
  add(query_594162, "uploadType", newJString(uploadType))
  add(path_594161, "parent", newJString(parent))
  add(query_594162, "key", newJString(key))
  add(query_594162, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594163 = body
  add(query_594162, "prettyPrint", newJBool(prettyPrint))
  result = call_594160.call(path_594161, query_594162, nil, nil, body_594163)

var dlpProjectsContentReidentify* = Call_DlpProjectsContentReidentify_594143(
    name: "dlpProjectsContentReidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/content:reidentify",
    validator: validate_DlpProjectsContentReidentify_594144, base: "/",
    url: url_DlpProjectsContentReidentify_594145, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsDeidentifyTemplatesCreate_594186 = ref object of OpenApiRestCall_593421
proc url_DlpOrganizationsDeidentifyTemplatesCreate_594188(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpOrganizationsDeidentifyTemplatesCreate_594187(path: JsonNode;
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
  var valid_594189 = path.getOrDefault("parent")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "parent", valid_594189
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
  var valid_594190 = query.getOrDefault("upload_protocol")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "upload_protocol", valid_594190
  var valid_594191 = query.getOrDefault("fields")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "fields", valid_594191
  var valid_594192 = query.getOrDefault("quotaUser")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "quotaUser", valid_594192
  var valid_594193 = query.getOrDefault("alt")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = newJString("json"))
  if valid_594193 != nil:
    section.add "alt", valid_594193
  var valid_594194 = query.getOrDefault("oauth_token")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "oauth_token", valid_594194
  var valid_594195 = query.getOrDefault("callback")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "callback", valid_594195
  var valid_594196 = query.getOrDefault("access_token")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = nil)
  if valid_594196 != nil:
    section.add "access_token", valid_594196
  var valid_594197 = query.getOrDefault("uploadType")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "uploadType", valid_594197
  var valid_594198 = query.getOrDefault("key")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "key", valid_594198
  var valid_594199 = query.getOrDefault("$.xgafv")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = newJString("1"))
  if valid_594199 != nil:
    section.add "$.xgafv", valid_594199
  var valid_594200 = query.getOrDefault("prettyPrint")
  valid_594200 = validateParameter(valid_594200, JBool, required = false,
                                 default = newJBool(true))
  if valid_594200 != nil:
    section.add "prettyPrint", valid_594200
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

proc call*(call_594202: Call_DlpOrganizationsDeidentifyTemplatesCreate_594186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a DeidentifyTemplate for re-using frequently used configuration
  ## for de-identifying content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ## 
  let valid = call_594202.validator(path, query, header, formData, body)
  let scheme = call_594202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594202.url(scheme.get, call_594202.host, call_594202.base,
                         call_594202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594202, url, valid)

proc call*(call_594203: Call_DlpOrganizationsDeidentifyTemplatesCreate_594186;
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
  var path_594204 = newJObject()
  var query_594205 = newJObject()
  var body_594206 = newJObject()
  add(query_594205, "upload_protocol", newJString(uploadProtocol))
  add(query_594205, "fields", newJString(fields))
  add(query_594205, "quotaUser", newJString(quotaUser))
  add(query_594205, "alt", newJString(alt))
  add(query_594205, "oauth_token", newJString(oauthToken))
  add(query_594205, "callback", newJString(callback))
  add(query_594205, "access_token", newJString(accessToken))
  add(query_594205, "uploadType", newJString(uploadType))
  add(path_594204, "parent", newJString(parent))
  add(query_594205, "key", newJString(key))
  add(query_594205, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594206 = body
  add(query_594205, "prettyPrint", newJBool(prettyPrint))
  result = call_594203.call(path_594204, query_594205, nil, nil, body_594206)

var dlpOrganizationsDeidentifyTemplatesCreate* = Call_DlpOrganizationsDeidentifyTemplatesCreate_594186(
    name: "dlpOrganizationsDeidentifyTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/deidentifyTemplates",
    validator: validate_DlpOrganizationsDeidentifyTemplatesCreate_594187,
    base: "/", url: url_DlpOrganizationsDeidentifyTemplatesCreate_594188,
    schemes: {Scheme.Https})
type
  Call_DlpOrganizationsDeidentifyTemplatesList_594164 = ref object of OpenApiRestCall_593421
proc url_DlpOrganizationsDeidentifyTemplatesList_594166(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpOrganizationsDeidentifyTemplatesList_594165(path: JsonNode;
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
  var valid_594167 = path.getOrDefault("parent")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "parent", valid_594167
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
  var valid_594168 = query.getOrDefault("upload_protocol")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "upload_protocol", valid_594168
  var valid_594169 = query.getOrDefault("fields")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "fields", valid_594169
  var valid_594170 = query.getOrDefault("pageToken")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "pageToken", valid_594170
  var valid_594171 = query.getOrDefault("quotaUser")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "quotaUser", valid_594171
  var valid_594172 = query.getOrDefault("alt")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = newJString("json"))
  if valid_594172 != nil:
    section.add "alt", valid_594172
  var valid_594173 = query.getOrDefault("oauth_token")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = nil)
  if valid_594173 != nil:
    section.add "oauth_token", valid_594173
  var valid_594174 = query.getOrDefault("callback")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "callback", valid_594174
  var valid_594175 = query.getOrDefault("access_token")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "access_token", valid_594175
  var valid_594176 = query.getOrDefault("uploadType")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = nil)
  if valid_594176 != nil:
    section.add "uploadType", valid_594176
  var valid_594177 = query.getOrDefault("orderBy")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "orderBy", valid_594177
  var valid_594178 = query.getOrDefault("key")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "key", valid_594178
  var valid_594179 = query.getOrDefault("$.xgafv")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = newJString("1"))
  if valid_594179 != nil:
    section.add "$.xgafv", valid_594179
  var valid_594180 = query.getOrDefault("pageSize")
  valid_594180 = validateParameter(valid_594180, JInt, required = false, default = nil)
  if valid_594180 != nil:
    section.add "pageSize", valid_594180
  var valid_594181 = query.getOrDefault("prettyPrint")
  valid_594181 = validateParameter(valid_594181, JBool, required = false,
                                 default = newJBool(true))
  if valid_594181 != nil:
    section.add "prettyPrint", valid_594181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594182: Call_DlpOrganizationsDeidentifyTemplatesList_594164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists DeidentifyTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates-deid to learn
  ## more.
  ## 
  let valid = call_594182.validator(path, query, header, formData, body)
  let scheme = call_594182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594182.url(scheme.get, call_594182.host, call_594182.base,
                         call_594182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594182, url, valid)

proc call*(call_594183: Call_DlpOrganizationsDeidentifyTemplatesList_594164;
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
  var path_594184 = newJObject()
  var query_594185 = newJObject()
  add(query_594185, "upload_protocol", newJString(uploadProtocol))
  add(query_594185, "fields", newJString(fields))
  add(query_594185, "pageToken", newJString(pageToken))
  add(query_594185, "quotaUser", newJString(quotaUser))
  add(query_594185, "alt", newJString(alt))
  add(query_594185, "oauth_token", newJString(oauthToken))
  add(query_594185, "callback", newJString(callback))
  add(query_594185, "access_token", newJString(accessToken))
  add(query_594185, "uploadType", newJString(uploadType))
  add(path_594184, "parent", newJString(parent))
  add(query_594185, "orderBy", newJString(orderBy))
  add(query_594185, "key", newJString(key))
  add(query_594185, "$.xgafv", newJString(Xgafv))
  add(query_594185, "pageSize", newJInt(pageSize))
  add(query_594185, "prettyPrint", newJBool(prettyPrint))
  result = call_594183.call(path_594184, query_594185, nil, nil, nil)

var dlpOrganizationsDeidentifyTemplatesList* = Call_DlpOrganizationsDeidentifyTemplatesList_594164(
    name: "dlpOrganizationsDeidentifyTemplatesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/deidentifyTemplates",
    validator: validate_DlpOrganizationsDeidentifyTemplatesList_594165, base: "/",
    url: url_DlpOrganizationsDeidentifyTemplatesList_594166,
    schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsCreate_594231 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsDlpJobsCreate_594233(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpProjectsDlpJobsCreate_594232(path: JsonNode; query: JsonNode;
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
  var valid_594234 = path.getOrDefault("parent")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "parent", valid_594234
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
  var valid_594235 = query.getOrDefault("upload_protocol")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "upload_protocol", valid_594235
  var valid_594236 = query.getOrDefault("fields")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "fields", valid_594236
  var valid_594237 = query.getOrDefault("quotaUser")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "quotaUser", valid_594237
  var valid_594238 = query.getOrDefault("alt")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = newJString("json"))
  if valid_594238 != nil:
    section.add "alt", valid_594238
  var valid_594239 = query.getOrDefault("oauth_token")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "oauth_token", valid_594239
  var valid_594240 = query.getOrDefault("callback")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "callback", valid_594240
  var valid_594241 = query.getOrDefault("access_token")
  valid_594241 = validateParameter(valid_594241, JString, required = false,
                                 default = nil)
  if valid_594241 != nil:
    section.add "access_token", valid_594241
  var valid_594242 = query.getOrDefault("uploadType")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "uploadType", valid_594242
  var valid_594243 = query.getOrDefault("key")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "key", valid_594243
  var valid_594244 = query.getOrDefault("$.xgafv")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = newJString("1"))
  if valid_594244 != nil:
    section.add "$.xgafv", valid_594244
  var valid_594245 = query.getOrDefault("prettyPrint")
  valid_594245 = validateParameter(valid_594245, JBool, required = false,
                                 default = newJBool(true))
  if valid_594245 != nil:
    section.add "prettyPrint", valid_594245
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

proc call*(call_594247: Call_DlpProjectsDlpJobsCreate_594231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new job to inspect storage or calculate risk metrics.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  ## When no InfoTypes or CustomInfoTypes are specified in inspect jobs, the
  ## system will automatically choose what detectors to run. By default this may
  ## be all types, but may change over time as detectors are updated.
  ## 
  let valid = call_594247.validator(path, query, header, formData, body)
  let scheme = call_594247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594247.url(scheme.get, call_594247.host, call_594247.base,
                         call_594247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594247, url, valid)

proc call*(call_594248: Call_DlpProjectsDlpJobsCreate_594231; parent: string;
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
  var path_594249 = newJObject()
  var query_594250 = newJObject()
  var body_594251 = newJObject()
  add(query_594250, "upload_protocol", newJString(uploadProtocol))
  add(query_594250, "fields", newJString(fields))
  add(query_594250, "quotaUser", newJString(quotaUser))
  add(query_594250, "alt", newJString(alt))
  add(query_594250, "oauth_token", newJString(oauthToken))
  add(query_594250, "callback", newJString(callback))
  add(query_594250, "access_token", newJString(accessToken))
  add(query_594250, "uploadType", newJString(uploadType))
  add(path_594249, "parent", newJString(parent))
  add(query_594250, "key", newJString(key))
  add(query_594250, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594251 = body
  add(query_594250, "prettyPrint", newJBool(prettyPrint))
  result = call_594248.call(path_594249, query_594250, nil, nil, body_594251)

var dlpProjectsDlpJobsCreate* = Call_DlpProjectsDlpJobsCreate_594231(
    name: "dlpProjectsDlpJobsCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/dlpJobs",
    validator: validate_DlpProjectsDlpJobsCreate_594232, base: "/",
    url: url_DlpProjectsDlpJobsCreate_594233, schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsList_594207 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsDlpJobsList_594209(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpProjectsDlpJobsList_594208(path: JsonNode; query: JsonNode;
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
  var valid_594210 = path.getOrDefault("parent")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "parent", valid_594210
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
  var valid_594211 = query.getOrDefault("upload_protocol")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "upload_protocol", valid_594211
  var valid_594212 = query.getOrDefault("fields")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "fields", valid_594212
  var valid_594213 = query.getOrDefault("pageToken")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = nil)
  if valid_594213 != nil:
    section.add "pageToken", valid_594213
  var valid_594214 = query.getOrDefault("quotaUser")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "quotaUser", valid_594214
  var valid_594215 = query.getOrDefault("alt")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = newJString("json"))
  if valid_594215 != nil:
    section.add "alt", valid_594215
  var valid_594216 = query.getOrDefault("type")
  valid_594216 = validateParameter(valid_594216, JString, required = false, default = newJString(
      "DLP_JOB_TYPE_UNSPECIFIED"))
  if valid_594216 != nil:
    section.add "type", valid_594216
  var valid_594217 = query.getOrDefault("oauth_token")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "oauth_token", valid_594217
  var valid_594218 = query.getOrDefault("callback")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "callback", valid_594218
  var valid_594219 = query.getOrDefault("access_token")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "access_token", valid_594219
  var valid_594220 = query.getOrDefault("uploadType")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = nil)
  if valid_594220 != nil:
    section.add "uploadType", valid_594220
  var valid_594221 = query.getOrDefault("orderBy")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = nil)
  if valid_594221 != nil:
    section.add "orderBy", valid_594221
  var valid_594222 = query.getOrDefault("key")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "key", valid_594222
  var valid_594223 = query.getOrDefault("$.xgafv")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = newJString("1"))
  if valid_594223 != nil:
    section.add "$.xgafv", valid_594223
  var valid_594224 = query.getOrDefault("pageSize")
  valid_594224 = validateParameter(valid_594224, JInt, required = false, default = nil)
  if valid_594224 != nil:
    section.add "pageSize", valid_594224
  var valid_594225 = query.getOrDefault("prettyPrint")
  valid_594225 = validateParameter(valid_594225, JBool, required = false,
                                 default = newJBool(true))
  if valid_594225 != nil:
    section.add "prettyPrint", valid_594225
  var valid_594226 = query.getOrDefault("filter")
  valid_594226 = validateParameter(valid_594226, JString, required = false,
                                 default = nil)
  if valid_594226 != nil:
    section.add "filter", valid_594226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594227: Call_DlpProjectsDlpJobsList_594207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists DlpJobs that match the specified filter in the request.
  ## See https://cloud.google.com/dlp/docs/inspecting-storage and
  ## https://cloud.google.com/dlp/docs/compute-risk-analysis to learn more.
  ## 
  let valid = call_594227.validator(path, query, header, formData, body)
  let scheme = call_594227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594227.url(scheme.get, call_594227.host, call_594227.base,
                         call_594227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594227, url, valid)

proc call*(call_594228: Call_DlpProjectsDlpJobsList_594207; parent: string;
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
  var path_594229 = newJObject()
  var query_594230 = newJObject()
  add(query_594230, "upload_protocol", newJString(uploadProtocol))
  add(query_594230, "fields", newJString(fields))
  add(query_594230, "pageToken", newJString(pageToken))
  add(query_594230, "quotaUser", newJString(quotaUser))
  add(query_594230, "alt", newJString(alt))
  add(query_594230, "type", newJString(`type`))
  add(query_594230, "oauth_token", newJString(oauthToken))
  add(query_594230, "callback", newJString(callback))
  add(query_594230, "access_token", newJString(accessToken))
  add(query_594230, "uploadType", newJString(uploadType))
  add(path_594229, "parent", newJString(parent))
  add(query_594230, "orderBy", newJString(orderBy))
  add(query_594230, "key", newJString(key))
  add(query_594230, "$.xgafv", newJString(Xgafv))
  add(query_594230, "pageSize", newJInt(pageSize))
  add(query_594230, "prettyPrint", newJBool(prettyPrint))
  add(query_594230, "filter", newJString(filter))
  result = call_594228.call(path_594229, query_594230, nil, nil, nil)

var dlpProjectsDlpJobsList* = Call_DlpProjectsDlpJobsList_594207(
    name: "dlpProjectsDlpJobsList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/dlpJobs",
    validator: validate_DlpProjectsDlpJobsList_594208, base: "/",
    url: url_DlpProjectsDlpJobsList_594209, schemes: {Scheme.Https})
type
  Call_DlpProjectsImageRedact_594252 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsImageRedact_594254(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpProjectsImageRedact_594253(path: JsonNode; query: JsonNode;
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
  var valid_594255 = path.getOrDefault("parent")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "parent", valid_594255
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
  var valid_594256 = query.getOrDefault("upload_protocol")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "upload_protocol", valid_594256
  var valid_594257 = query.getOrDefault("fields")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = nil)
  if valid_594257 != nil:
    section.add "fields", valid_594257
  var valid_594258 = query.getOrDefault("quotaUser")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = nil)
  if valid_594258 != nil:
    section.add "quotaUser", valid_594258
  var valid_594259 = query.getOrDefault("alt")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = newJString("json"))
  if valid_594259 != nil:
    section.add "alt", valid_594259
  var valid_594260 = query.getOrDefault("oauth_token")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "oauth_token", valid_594260
  var valid_594261 = query.getOrDefault("callback")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "callback", valid_594261
  var valid_594262 = query.getOrDefault("access_token")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = nil)
  if valid_594262 != nil:
    section.add "access_token", valid_594262
  var valid_594263 = query.getOrDefault("uploadType")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = nil)
  if valid_594263 != nil:
    section.add "uploadType", valid_594263
  var valid_594264 = query.getOrDefault("key")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = nil)
  if valid_594264 != nil:
    section.add "key", valid_594264
  var valid_594265 = query.getOrDefault("$.xgafv")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = newJString("1"))
  if valid_594265 != nil:
    section.add "$.xgafv", valid_594265
  var valid_594266 = query.getOrDefault("prettyPrint")
  valid_594266 = validateParameter(valid_594266, JBool, required = false,
                                 default = newJBool(true))
  if valid_594266 != nil:
    section.add "prettyPrint", valid_594266
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

proc call*(call_594268: Call_DlpProjectsImageRedact_594252; path: JsonNode;
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
  let valid = call_594268.validator(path, query, header, formData, body)
  let scheme = call_594268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594268.url(scheme.get, call_594268.host, call_594268.base,
                         call_594268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594268, url, valid)

proc call*(call_594269: Call_DlpProjectsImageRedact_594252; parent: string;
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
  var path_594270 = newJObject()
  var query_594271 = newJObject()
  var body_594272 = newJObject()
  add(query_594271, "upload_protocol", newJString(uploadProtocol))
  add(query_594271, "fields", newJString(fields))
  add(query_594271, "quotaUser", newJString(quotaUser))
  add(query_594271, "alt", newJString(alt))
  add(query_594271, "oauth_token", newJString(oauthToken))
  add(query_594271, "callback", newJString(callback))
  add(query_594271, "access_token", newJString(accessToken))
  add(query_594271, "uploadType", newJString(uploadType))
  add(path_594270, "parent", newJString(parent))
  add(query_594271, "key", newJString(key))
  add(query_594271, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594272 = body
  add(query_594271, "prettyPrint", newJBool(prettyPrint))
  result = call_594269.call(path_594270, query_594271, nil, nil, body_594272)

var dlpProjectsImageRedact* = Call_DlpProjectsImageRedact_594252(
    name: "dlpProjectsImageRedact", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/image:redact",
    validator: validate_DlpProjectsImageRedact_594253, base: "/",
    url: url_DlpProjectsImageRedact_594254, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsInspectTemplatesCreate_594295 = ref object of OpenApiRestCall_593421
proc url_DlpOrganizationsInspectTemplatesCreate_594297(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpOrganizationsInspectTemplatesCreate_594296(path: JsonNode;
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
  var valid_594298 = path.getOrDefault("parent")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "parent", valid_594298
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
  var valid_594299 = query.getOrDefault("upload_protocol")
  valid_594299 = validateParameter(valid_594299, JString, required = false,
                                 default = nil)
  if valid_594299 != nil:
    section.add "upload_protocol", valid_594299
  var valid_594300 = query.getOrDefault("fields")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = nil)
  if valid_594300 != nil:
    section.add "fields", valid_594300
  var valid_594301 = query.getOrDefault("quotaUser")
  valid_594301 = validateParameter(valid_594301, JString, required = false,
                                 default = nil)
  if valid_594301 != nil:
    section.add "quotaUser", valid_594301
  var valid_594302 = query.getOrDefault("alt")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = newJString("json"))
  if valid_594302 != nil:
    section.add "alt", valid_594302
  var valid_594303 = query.getOrDefault("oauth_token")
  valid_594303 = validateParameter(valid_594303, JString, required = false,
                                 default = nil)
  if valid_594303 != nil:
    section.add "oauth_token", valid_594303
  var valid_594304 = query.getOrDefault("callback")
  valid_594304 = validateParameter(valid_594304, JString, required = false,
                                 default = nil)
  if valid_594304 != nil:
    section.add "callback", valid_594304
  var valid_594305 = query.getOrDefault("access_token")
  valid_594305 = validateParameter(valid_594305, JString, required = false,
                                 default = nil)
  if valid_594305 != nil:
    section.add "access_token", valid_594305
  var valid_594306 = query.getOrDefault("uploadType")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = nil)
  if valid_594306 != nil:
    section.add "uploadType", valid_594306
  var valid_594307 = query.getOrDefault("key")
  valid_594307 = validateParameter(valid_594307, JString, required = false,
                                 default = nil)
  if valid_594307 != nil:
    section.add "key", valid_594307
  var valid_594308 = query.getOrDefault("$.xgafv")
  valid_594308 = validateParameter(valid_594308, JString, required = false,
                                 default = newJString("1"))
  if valid_594308 != nil:
    section.add "$.xgafv", valid_594308
  var valid_594309 = query.getOrDefault("prettyPrint")
  valid_594309 = validateParameter(valid_594309, JBool, required = false,
                                 default = newJBool(true))
  if valid_594309 != nil:
    section.add "prettyPrint", valid_594309
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

proc call*(call_594311: Call_DlpOrganizationsInspectTemplatesCreate_594295;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an InspectTemplate for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  let valid = call_594311.validator(path, query, header, formData, body)
  let scheme = call_594311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594311.url(scheme.get, call_594311.host, call_594311.base,
                         call_594311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594311, url, valid)

proc call*(call_594312: Call_DlpOrganizationsInspectTemplatesCreate_594295;
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
  var path_594313 = newJObject()
  var query_594314 = newJObject()
  var body_594315 = newJObject()
  add(query_594314, "upload_protocol", newJString(uploadProtocol))
  add(query_594314, "fields", newJString(fields))
  add(query_594314, "quotaUser", newJString(quotaUser))
  add(query_594314, "alt", newJString(alt))
  add(query_594314, "oauth_token", newJString(oauthToken))
  add(query_594314, "callback", newJString(callback))
  add(query_594314, "access_token", newJString(accessToken))
  add(query_594314, "uploadType", newJString(uploadType))
  add(path_594313, "parent", newJString(parent))
  add(query_594314, "key", newJString(key))
  add(query_594314, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594315 = body
  add(query_594314, "prettyPrint", newJBool(prettyPrint))
  result = call_594312.call(path_594313, query_594314, nil, nil, body_594315)

var dlpOrganizationsInspectTemplatesCreate* = Call_DlpOrganizationsInspectTemplatesCreate_594295(
    name: "dlpOrganizationsInspectTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/inspectTemplates",
    validator: validate_DlpOrganizationsInspectTemplatesCreate_594296, base: "/",
    url: url_DlpOrganizationsInspectTemplatesCreate_594297,
    schemes: {Scheme.Https})
type
  Call_DlpOrganizationsInspectTemplatesList_594273 = ref object of OpenApiRestCall_593421
proc url_DlpOrganizationsInspectTemplatesList_594275(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpOrganizationsInspectTemplatesList_594274(path: JsonNode;
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
  var valid_594276 = path.getOrDefault("parent")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "parent", valid_594276
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
  var valid_594277 = query.getOrDefault("upload_protocol")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "upload_protocol", valid_594277
  var valid_594278 = query.getOrDefault("fields")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "fields", valid_594278
  var valid_594279 = query.getOrDefault("pageToken")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "pageToken", valid_594279
  var valid_594280 = query.getOrDefault("quotaUser")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = nil)
  if valid_594280 != nil:
    section.add "quotaUser", valid_594280
  var valid_594281 = query.getOrDefault("alt")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = newJString("json"))
  if valid_594281 != nil:
    section.add "alt", valid_594281
  var valid_594282 = query.getOrDefault("oauth_token")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = nil)
  if valid_594282 != nil:
    section.add "oauth_token", valid_594282
  var valid_594283 = query.getOrDefault("callback")
  valid_594283 = validateParameter(valid_594283, JString, required = false,
                                 default = nil)
  if valid_594283 != nil:
    section.add "callback", valid_594283
  var valid_594284 = query.getOrDefault("access_token")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = nil)
  if valid_594284 != nil:
    section.add "access_token", valid_594284
  var valid_594285 = query.getOrDefault("uploadType")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = nil)
  if valid_594285 != nil:
    section.add "uploadType", valid_594285
  var valid_594286 = query.getOrDefault("orderBy")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = nil)
  if valid_594286 != nil:
    section.add "orderBy", valid_594286
  var valid_594287 = query.getOrDefault("key")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = nil)
  if valid_594287 != nil:
    section.add "key", valid_594287
  var valid_594288 = query.getOrDefault("$.xgafv")
  valid_594288 = validateParameter(valid_594288, JString, required = false,
                                 default = newJString("1"))
  if valid_594288 != nil:
    section.add "$.xgafv", valid_594288
  var valid_594289 = query.getOrDefault("pageSize")
  valid_594289 = validateParameter(valid_594289, JInt, required = false, default = nil)
  if valid_594289 != nil:
    section.add "pageSize", valid_594289
  var valid_594290 = query.getOrDefault("prettyPrint")
  valid_594290 = validateParameter(valid_594290, JBool, required = false,
                                 default = newJBool(true))
  if valid_594290 != nil:
    section.add "prettyPrint", valid_594290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594291: Call_DlpOrganizationsInspectTemplatesList_594273;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists InspectTemplates.
  ## See https://cloud.google.com/dlp/docs/creating-templates to learn more.
  ## 
  let valid = call_594291.validator(path, query, header, formData, body)
  let scheme = call_594291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594291.url(scheme.get, call_594291.host, call_594291.base,
                         call_594291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594291, url, valid)

proc call*(call_594292: Call_DlpOrganizationsInspectTemplatesList_594273;
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
  var path_594293 = newJObject()
  var query_594294 = newJObject()
  add(query_594294, "upload_protocol", newJString(uploadProtocol))
  add(query_594294, "fields", newJString(fields))
  add(query_594294, "pageToken", newJString(pageToken))
  add(query_594294, "quotaUser", newJString(quotaUser))
  add(query_594294, "alt", newJString(alt))
  add(query_594294, "oauth_token", newJString(oauthToken))
  add(query_594294, "callback", newJString(callback))
  add(query_594294, "access_token", newJString(accessToken))
  add(query_594294, "uploadType", newJString(uploadType))
  add(path_594293, "parent", newJString(parent))
  add(query_594294, "orderBy", newJString(orderBy))
  add(query_594294, "key", newJString(key))
  add(query_594294, "$.xgafv", newJString(Xgafv))
  add(query_594294, "pageSize", newJInt(pageSize))
  add(query_594294, "prettyPrint", newJBool(prettyPrint))
  result = call_594292.call(path_594293, query_594294, nil, nil, nil)

var dlpOrganizationsInspectTemplatesList* = Call_DlpOrganizationsInspectTemplatesList_594273(
    name: "dlpOrganizationsInspectTemplatesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/inspectTemplates",
    validator: validate_DlpOrganizationsInspectTemplatesList_594274, base: "/",
    url: url_DlpOrganizationsInspectTemplatesList_594275, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersCreate_594339 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsJobTriggersCreate_594341(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpProjectsJobTriggersCreate_594340(path: JsonNode; query: JsonNode;
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
  var valid_594342 = path.getOrDefault("parent")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "parent", valid_594342
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
  var valid_594343 = query.getOrDefault("upload_protocol")
  valid_594343 = validateParameter(valid_594343, JString, required = false,
                                 default = nil)
  if valid_594343 != nil:
    section.add "upload_protocol", valid_594343
  var valid_594344 = query.getOrDefault("fields")
  valid_594344 = validateParameter(valid_594344, JString, required = false,
                                 default = nil)
  if valid_594344 != nil:
    section.add "fields", valid_594344
  var valid_594345 = query.getOrDefault("quotaUser")
  valid_594345 = validateParameter(valid_594345, JString, required = false,
                                 default = nil)
  if valid_594345 != nil:
    section.add "quotaUser", valid_594345
  var valid_594346 = query.getOrDefault("alt")
  valid_594346 = validateParameter(valid_594346, JString, required = false,
                                 default = newJString("json"))
  if valid_594346 != nil:
    section.add "alt", valid_594346
  var valid_594347 = query.getOrDefault("oauth_token")
  valid_594347 = validateParameter(valid_594347, JString, required = false,
                                 default = nil)
  if valid_594347 != nil:
    section.add "oauth_token", valid_594347
  var valid_594348 = query.getOrDefault("callback")
  valid_594348 = validateParameter(valid_594348, JString, required = false,
                                 default = nil)
  if valid_594348 != nil:
    section.add "callback", valid_594348
  var valid_594349 = query.getOrDefault("access_token")
  valid_594349 = validateParameter(valid_594349, JString, required = false,
                                 default = nil)
  if valid_594349 != nil:
    section.add "access_token", valid_594349
  var valid_594350 = query.getOrDefault("uploadType")
  valid_594350 = validateParameter(valid_594350, JString, required = false,
                                 default = nil)
  if valid_594350 != nil:
    section.add "uploadType", valid_594350
  var valid_594351 = query.getOrDefault("key")
  valid_594351 = validateParameter(valid_594351, JString, required = false,
                                 default = nil)
  if valid_594351 != nil:
    section.add "key", valid_594351
  var valid_594352 = query.getOrDefault("$.xgafv")
  valid_594352 = validateParameter(valid_594352, JString, required = false,
                                 default = newJString("1"))
  if valid_594352 != nil:
    section.add "$.xgafv", valid_594352
  var valid_594353 = query.getOrDefault("prettyPrint")
  valid_594353 = validateParameter(valid_594353, JBool, required = false,
                                 default = newJBool(true))
  if valid_594353 != nil:
    section.add "prettyPrint", valid_594353
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

proc call*(call_594355: Call_DlpProjectsJobTriggersCreate_594339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a job trigger to run DLP actions such as scanning storage for
  ## sensitive information on a set schedule.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ## 
  let valid = call_594355.validator(path, query, header, formData, body)
  let scheme = call_594355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594355.url(scheme.get, call_594355.host, call_594355.base,
                         call_594355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594355, url, valid)

proc call*(call_594356: Call_DlpProjectsJobTriggersCreate_594339; parent: string;
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
  var path_594357 = newJObject()
  var query_594358 = newJObject()
  var body_594359 = newJObject()
  add(query_594358, "upload_protocol", newJString(uploadProtocol))
  add(query_594358, "fields", newJString(fields))
  add(query_594358, "quotaUser", newJString(quotaUser))
  add(query_594358, "alt", newJString(alt))
  add(query_594358, "oauth_token", newJString(oauthToken))
  add(query_594358, "callback", newJString(callback))
  add(query_594358, "access_token", newJString(accessToken))
  add(query_594358, "uploadType", newJString(uploadType))
  add(path_594357, "parent", newJString(parent))
  add(query_594358, "key", newJString(key))
  add(query_594358, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594359 = body
  add(query_594358, "prettyPrint", newJBool(prettyPrint))
  result = call_594356.call(path_594357, query_594358, nil, nil, body_594359)

var dlpProjectsJobTriggersCreate* = Call_DlpProjectsJobTriggersCreate_594339(
    name: "dlpProjectsJobTriggersCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/jobTriggers",
    validator: validate_DlpProjectsJobTriggersCreate_594340, base: "/",
    url: url_DlpProjectsJobTriggersCreate_594341, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersList_594316 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsJobTriggersList_594318(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpProjectsJobTriggersList_594317(path: JsonNode; query: JsonNode;
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
  var valid_594319 = path.getOrDefault("parent")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "parent", valid_594319
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
  var valid_594320 = query.getOrDefault("upload_protocol")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = nil)
  if valid_594320 != nil:
    section.add "upload_protocol", valid_594320
  var valid_594321 = query.getOrDefault("fields")
  valid_594321 = validateParameter(valid_594321, JString, required = false,
                                 default = nil)
  if valid_594321 != nil:
    section.add "fields", valid_594321
  var valid_594322 = query.getOrDefault("pageToken")
  valid_594322 = validateParameter(valid_594322, JString, required = false,
                                 default = nil)
  if valid_594322 != nil:
    section.add "pageToken", valid_594322
  var valid_594323 = query.getOrDefault("quotaUser")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = nil)
  if valid_594323 != nil:
    section.add "quotaUser", valid_594323
  var valid_594324 = query.getOrDefault("alt")
  valid_594324 = validateParameter(valid_594324, JString, required = false,
                                 default = newJString("json"))
  if valid_594324 != nil:
    section.add "alt", valid_594324
  var valid_594325 = query.getOrDefault("oauth_token")
  valid_594325 = validateParameter(valid_594325, JString, required = false,
                                 default = nil)
  if valid_594325 != nil:
    section.add "oauth_token", valid_594325
  var valid_594326 = query.getOrDefault("callback")
  valid_594326 = validateParameter(valid_594326, JString, required = false,
                                 default = nil)
  if valid_594326 != nil:
    section.add "callback", valid_594326
  var valid_594327 = query.getOrDefault("access_token")
  valid_594327 = validateParameter(valid_594327, JString, required = false,
                                 default = nil)
  if valid_594327 != nil:
    section.add "access_token", valid_594327
  var valid_594328 = query.getOrDefault("uploadType")
  valid_594328 = validateParameter(valid_594328, JString, required = false,
                                 default = nil)
  if valid_594328 != nil:
    section.add "uploadType", valid_594328
  var valid_594329 = query.getOrDefault("orderBy")
  valid_594329 = validateParameter(valid_594329, JString, required = false,
                                 default = nil)
  if valid_594329 != nil:
    section.add "orderBy", valid_594329
  var valid_594330 = query.getOrDefault("key")
  valid_594330 = validateParameter(valid_594330, JString, required = false,
                                 default = nil)
  if valid_594330 != nil:
    section.add "key", valid_594330
  var valid_594331 = query.getOrDefault("$.xgafv")
  valid_594331 = validateParameter(valid_594331, JString, required = false,
                                 default = newJString("1"))
  if valid_594331 != nil:
    section.add "$.xgafv", valid_594331
  var valid_594332 = query.getOrDefault("pageSize")
  valid_594332 = validateParameter(valid_594332, JInt, required = false, default = nil)
  if valid_594332 != nil:
    section.add "pageSize", valid_594332
  var valid_594333 = query.getOrDefault("prettyPrint")
  valid_594333 = validateParameter(valid_594333, JBool, required = false,
                                 default = newJBool(true))
  if valid_594333 != nil:
    section.add "prettyPrint", valid_594333
  var valid_594334 = query.getOrDefault("filter")
  valid_594334 = validateParameter(valid_594334, JString, required = false,
                                 default = nil)
  if valid_594334 != nil:
    section.add "filter", valid_594334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594335: Call_DlpProjectsJobTriggersList_594316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists job triggers.
  ## See https://cloud.google.com/dlp/docs/creating-job-triggers to learn more.
  ## 
  let valid = call_594335.validator(path, query, header, formData, body)
  let scheme = call_594335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594335.url(scheme.get, call_594335.host, call_594335.base,
                         call_594335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594335, url, valid)

proc call*(call_594336: Call_DlpProjectsJobTriggersList_594316; parent: string;
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
  var path_594337 = newJObject()
  var query_594338 = newJObject()
  add(query_594338, "upload_protocol", newJString(uploadProtocol))
  add(query_594338, "fields", newJString(fields))
  add(query_594338, "pageToken", newJString(pageToken))
  add(query_594338, "quotaUser", newJString(quotaUser))
  add(query_594338, "alt", newJString(alt))
  add(query_594338, "oauth_token", newJString(oauthToken))
  add(query_594338, "callback", newJString(callback))
  add(query_594338, "access_token", newJString(accessToken))
  add(query_594338, "uploadType", newJString(uploadType))
  add(path_594337, "parent", newJString(parent))
  add(query_594338, "orderBy", newJString(orderBy))
  add(query_594338, "key", newJString(key))
  add(query_594338, "$.xgafv", newJString(Xgafv))
  add(query_594338, "pageSize", newJInt(pageSize))
  add(query_594338, "prettyPrint", newJBool(prettyPrint))
  add(query_594338, "filter", newJString(filter))
  result = call_594336.call(path_594337, query_594338, nil, nil, nil)

var dlpProjectsJobTriggersList* = Call_DlpProjectsJobTriggersList_594316(
    name: "dlpProjectsJobTriggersList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/jobTriggers",
    validator: validate_DlpProjectsJobTriggersList_594317, base: "/",
    url: url_DlpProjectsJobTriggersList_594318, schemes: {Scheme.Https})
type
  Call_DlpProjectsLocationsContentDeidentify_594360 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsLocationsContentDeidentify_594362(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpProjectsLocationsContentDeidentify_594361(path: JsonNode;
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
  var valid_594363 = path.getOrDefault("parent")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = nil)
  if valid_594363 != nil:
    section.add "parent", valid_594363
  var valid_594364 = path.getOrDefault("location")
  valid_594364 = validateParameter(valid_594364, JString, required = true,
                                 default = nil)
  if valid_594364 != nil:
    section.add "location", valid_594364
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
  var valid_594365 = query.getOrDefault("upload_protocol")
  valid_594365 = validateParameter(valid_594365, JString, required = false,
                                 default = nil)
  if valid_594365 != nil:
    section.add "upload_protocol", valid_594365
  var valid_594366 = query.getOrDefault("fields")
  valid_594366 = validateParameter(valid_594366, JString, required = false,
                                 default = nil)
  if valid_594366 != nil:
    section.add "fields", valid_594366
  var valid_594367 = query.getOrDefault("quotaUser")
  valid_594367 = validateParameter(valid_594367, JString, required = false,
                                 default = nil)
  if valid_594367 != nil:
    section.add "quotaUser", valid_594367
  var valid_594368 = query.getOrDefault("alt")
  valid_594368 = validateParameter(valid_594368, JString, required = false,
                                 default = newJString("json"))
  if valid_594368 != nil:
    section.add "alt", valid_594368
  var valid_594369 = query.getOrDefault("oauth_token")
  valid_594369 = validateParameter(valid_594369, JString, required = false,
                                 default = nil)
  if valid_594369 != nil:
    section.add "oauth_token", valid_594369
  var valid_594370 = query.getOrDefault("callback")
  valid_594370 = validateParameter(valid_594370, JString, required = false,
                                 default = nil)
  if valid_594370 != nil:
    section.add "callback", valid_594370
  var valid_594371 = query.getOrDefault("access_token")
  valid_594371 = validateParameter(valid_594371, JString, required = false,
                                 default = nil)
  if valid_594371 != nil:
    section.add "access_token", valid_594371
  var valid_594372 = query.getOrDefault("uploadType")
  valid_594372 = validateParameter(valid_594372, JString, required = false,
                                 default = nil)
  if valid_594372 != nil:
    section.add "uploadType", valid_594372
  var valid_594373 = query.getOrDefault("key")
  valid_594373 = validateParameter(valid_594373, JString, required = false,
                                 default = nil)
  if valid_594373 != nil:
    section.add "key", valid_594373
  var valid_594374 = query.getOrDefault("$.xgafv")
  valid_594374 = validateParameter(valid_594374, JString, required = false,
                                 default = newJString("1"))
  if valid_594374 != nil:
    section.add "$.xgafv", valid_594374
  var valid_594375 = query.getOrDefault("prettyPrint")
  valid_594375 = validateParameter(valid_594375, JBool, required = false,
                                 default = newJBool(true))
  if valid_594375 != nil:
    section.add "prettyPrint", valid_594375
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

proc call*(call_594377: Call_DlpProjectsLocationsContentDeidentify_594360;
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
  let valid = call_594377.validator(path, query, header, formData, body)
  let scheme = call_594377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594377.url(scheme.get, call_594377.host, call_594377.base,
                         call_594377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594377, url, valid)

proc call*(call_594378: Call_DlpProjectsLocationsContentDeidentify_594360;
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
  var path_594379 = newJObject()
  var query_594380 = newJObject()
  var body_594381 = newJObject()
  add(query_594380, "upload_protocol", newJString(uploadProtocol))
  add(query_594380, "fields", newJString(fields))
  add(query_594380, "quotaUser", newJString(quotaUser))
  add(query_594380, "alt", newJString(alt))
  add(query_594380, "oauth_token", newJString(oauthToken))
  add(query_594380, "callback", newJString(callback))
  add(query_594380, "access_token", newJString(accessToken))
  add(query_594380, "uploadType", newJString(uploadType))
  add(path_594379, "parent", newJString(parent))
  add(query_594380, "key", newJString(key))
  add(query_594380, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594381 = body
  add(query_594380, "prettyPrint", newJBool(prettyPrint))
  add(path_594379, "location", newJString(location))
  result = call_594378.call(path_594379, query_594380, nil, nil, body_594381)

var dlpProjectsLocationsContentDeidentify* = Call_DlpProjectsLocationsContentDeidentify_594360(
    name: "dlpProjectsLocationsContentDeidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com",
    route: "/v2/{parent}/locations/{location}/content:deidentify",
    validator: validate_DlpProjectsLocationsContentDeidentify_594361, base: "/",
    url: url_DlpProjectsLocationsContentDeidentify_594362, schemes: {Scheme.Https})
type
  Call_DlpProjectsLocationsContentInspect_594382 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsLocationsContentInspect_594384(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpProjectsLocationsContentInspect_594383(path: JsonNode;
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
  var valid_594385 = path.getOrDefault("parent")
  valid_594385 = validateParameter(valid_594385, JString, required = true,
                                 default = nil)
  if valid_594385 != nil:
    section.add "parent", valid_594385
  var valid_594386 = path.getOrDefault("location")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = nil)
  if valid_594386 != nil:
    section.add "location", valid_594386
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
  var valid_594387 = query.getOrDefault("upload_protocol")
  valid_594387 = validateParameter(valid_594387, JString, required = false,
                                 default = nil)
  if valid_594387 != nil:
    section.add "upload_protocol", valid_594387
  var valid_594388 = query.getOrDefault("fields")
  valid_594388 = validateParameter(valid_594388, JString, required = false,
                                 default = nil)
  if valid_594388 != nil:
    section.add "fields", valid_594388
  var valid_594389 = query.getOrDefault("quotaUser")
  valid_594389 = validateParameter(valid_594389, JString, required = false,
                                 default = nil)
  if valid_594389 != nil:
    section.add "quotaUser", valid_594389
  var valid_594390 = query.getOrDefault("alt")
  valid_594390 = validateParameter(valid_594390, JString, required = false,
                                 default = newJString("json"))
  if valid_594390 != nil:
    section.add "alt", valid_594390
  var valid_594391 = query.getOrDefault("oauth_token")
  valid_594391 = validateParameter(valid_594391, JString, required = false,
                                 default = nil)
  if valid_594391 != nil:
    section.add "oauth_token", valid_594391
  var valid_594392 = query.getOrDefault("callback")
  valid_594392 = validateParameter(valid_594392, JString, required = false,
                                 default = nil)
  if valid_594392 != nil:
    section.add "callback", valid_594392
  var valid_594393 = query.getOrDefault("access_token")
  valid_594393 = validateParameter(valid_594393, JString, required = false,
                                 default = nil)
  if valid_594393 != nil:
    section.add "access_token", valid_594393
  var valid_594394 = query.getOrDefault("uploadType")
  valid_594394 = validateParameter(valid_594394, JString, required = false,
                                 default = nil)
  if valid_594394 != nil:
    section.add "uploadType", valid_594394
  var valid_594395 = query.getOrDefault("key")
  valid_594395 = validateParameter(valid_594395, JString, required = false,
                                 default = nil)
  if valid_594395 != nil:
    section.add "key", valid_594395
  var valid_594396 = query.getOrDefault("$.xgafv")
  valid_594396 = validateParameter(valid_594396, JString, required = false,
                                 default = newJString("1"))
  if valid_594396 != nil:
    section.add "$.xgafv", valid_594396
  var valid_594397 = query.getOrDefault("prettyPrint")
  valid_594397 = validateParameter(valid_594397, JBool, required = false,
                                 default = newJBool(true))
  if valid_594397 != nil:
    section.add "prettyPrint", valid_594397
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

proc call*(call_594399: Call_DlpProjectsLocationsContentInspect_594382;
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
  let valid = call_594399.validator(path, query, header, formData, body)
  let scheme = call_594399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594399.url(scheme.get, call_594399.host, call_594399.base,
                         call_594399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594399, url, valid)

proc call*(call_594400: Call_DlpProjectsLocationsContentInspect_594382;
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
  var path_594401 = newJObject()
  var query_594402 = newJObject()
  var body_594403 = newJObject()
  add(query_594402, "upload_protocol", newJString(uploadProtocol))
  add(query_594402, "fields", newJString(fields))
  add(query_594402, "quotaUser", newJString(quotaUser))
  add(query_594402, "alt", newJString(alt))
  add(query_594402, "oauth_token", newJString(oauthToken))
  add(query_594402, "callback", newJString(callback))
  add(query_594402, "access_token", newJString(accessToken))
  add(query_594402, "uploadType", newJString(uploadType))
  add(path_594401, "parent", newJString(parent))
  add(query_594402, "key", newJString(key))
  add(query_594402, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594403 = body
  add(query_594402, "prettyPrint", newJBool(prettyPrint))
  add(path_594401, "location", newJString(location))
  result = call_594400.call(path_594401, query_594402, nil, nil, body_594403)

var dlpProjectsLocationsContentInspect* = Call_DlpProjectsLocationsContentInspect_594382(
    name: "dlpProjectsLocationsContentInspect", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com",
    route: "/v2/{parent}/locations/{location}/content:inspect",
    validator: validate_DlpProjectsLocationsContentInspect_594383, base: "/",
    url: url_DlpProjectsLocationsContentInspect_594384, schemes: {Scheme.Https})
type
  Call_DlpProjectsLocationsContentReidentify_594404 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsLocationsContentReidentify_594406(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpProjectsLocationsContentReidentify_594405(path: JsonNode;
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
  var valid_594407 = path.getOrDefault("parent")
  valid_594407 = validateParameter(valid_594407, JString, required = true,
                                 default = nil)
  if valid_594407 != nil:
    section.add "parent", valid_594407
  var valid_594408 = path.getOrDefault("location")
  valid_594408 = validateParameter(valid_594408, JString, required = true,
                                 default = nil)
  if valid_594408 != nil:
    section.add "location", valid_594408
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
  var valid_594409 = query.getOrDefault("upload_protocol")
  valid_594409 = validateParameter(valid_594409, JString, required = false,
                                 default = nil)
  if valid_594409 != nil:
    section.add "upload_protocol", valid_594409
  var valid_594410 = query.getOrDefault("fields")
  valid_594410 = validateParameter(valid_594410, JString, required = false,
                                 default = nil)
  if valid_594410 != nil:
    section.add "fields", valid_594410
  var valid_594411 = query.getOrDefault("quotaUser")
  valid_594411 = validateParameter(valid_594411, JString, required = false,
                                 default = nil)
  if valid_594411 != nil:
    section.add "quotaUser", valid_594411
  var valid_594412 = query.getOrDefault("alt")
  valid_594412 = validateParameter(valid_594412, JString, required = false,
                                 default = newJString("json"))
  if valid_594412 != nil:
    section.add "alt", valid_594412
  var valid_594413 = query.getOrDefault("oauth_token")
  valid_594413 = validateParameter(valid_594413, JString, required = false,
                                 default = nil)
  if valid_594413 != nil:
    section.add "oauth_token", valid_594413
  var valid_594414 = query.getOrDefault("callback")
  valid_594414 = validateParameter(valid_594414, JString, required = false,
                                 default = nil)
  if valid_594414 != nil:
    section.add "callback", valid_594414
  var valid_594415 = query.getOrDefault("access_token")
  valid_594415 = validateParameter(valid_594415, JString, required = false,
                                 default = nil)
  if valid_594415 != nil:
    section.add "access_token", valid_594415
  var valid_594416 = query.getOrDefault("uploadType")
  valid_594416 = validateParameter(valid_594416, JString, required = false,
                                 default = nil)
  if valid_594416 != nil:
    section.add "uploadType", valid_594416
  var valid_594417 = query.getOrDefault("key")
  valid_594417 = validateParameter(valid_594417, JString, required = false,
                                 default = nil)
  if valid_594417 != nil:
    section.add "key", valid_594417
  var valid_594418 = query.getOrDefault("$.xgafv")
  valid_594418 = validateParameter(valid_594418, JString, required = false,
                                 default = newJString("1"))
  if valid_594418 != nil:
    section.add "$.xgafv", valid_594418
  var valid_594419 = query.getOrDefault("prettyPrint")
  valid_594419 = validateParameter(valid_594419, JBool, required = false,
                                 default = newJBool(true))
  if valid_594419 != nil:
    section.add "prettyPrint", valid_594419
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

proc call*(call_594421: Call_DlpProjectsLocationsContentReidentify_594404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Re-identifies content that has been de-identified.
  ## See
  ## https://cloud.google.com/dlp/docs/pseudonymization#re-identification_in_free_text_code_example
  ## to learn more.
  ## 
  let valid = call_594421.validator(path, query, header, formData, body)
  let scheme = call_594421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594421.url(scheme.get, call_594421.host, call_594421.base,
                         call_594421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594421, url, valid)

proc call*(call_594422: Call_DlpProjectsLocationsContentReidentify_594404;
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
  var path_594423 = newJObject()
  var query_594424 = newJObject()
  var body_594425 = newJObject()
  add(query_594424, "upload_protocol", newJString(uploadProtocol))
  add(query_594424, "fields", newJString(fields))
  add(query_594424, "quotaUser", newJString(quotaUser))
  add(query_594424, "alt", newJString(alt))
  add(query_594424, "oauth_token", newJString(oauthToken))
  add(query_594424, "callback", newJString(callback))
  add(query_594424, "access_token", newJString(accessToken))
  add(query_594424, "uploadType", newJString(uploadType))
  add(path_594423, "parent", newJString(parent))
  add(query_594424, "key", newJString(key))
  add(query_594424, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594425 = body
  add(query_594424, "prettyPrint", newJBool(prettyPrint))
  add(path_594423, "location", newJString(location))
  result = call_594422.call(path_594423, query_594424, nil, nil, body_594425)

var dlpProjectsLocationsContentReidentify* = Call_DlpProjectsLocationsContentReidentify_594404(
    name: "dlpProjectsLocationsContentReidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com",
    route: "/v2/{parent}/locations/{location}/content:reidentify",
    validator: validate_DlpProjectsLocationsContentReidentify_594405, base: "/",
    url: url_DlpProjectsLocationsContentReidentify_594406, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsStoredInfoTypesCreate_594448 = ref object of OpenApiRestCall_593421
proc url_DlpOrganizationsStoredInfoTypesCreate_594450(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpOrganizationsStoredInfoTypesCreate_594449(path: JsonNode;
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
  var valid_594451 = path.getOrDefault("parent")
  valid_594451 = validateParameter(valid_594451, JString, required = true,
                                 default = nil)
  if valid_594451 != nil:
    section.add "parent", valid_594451
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
  var valid_594452 = query.getOrDefault("upload_protocol")
  valid_594452 = validateParameter(valid_594452, JString, required = false,
                                 default = nil)
  if valid_594452 != nil:
    section.add "upload_protocol", valid_594452
  var valid_594453 = query.getOrDefault("fields")
  valid_594453 = validateParameter(valid_594453, JString, required = false,
                                 default = nil)
  if valid_594453 != nil:
    section.add "fields", valid_594453
  var valid_594454 = query.getOrDefault("quotaUser")
  valid_594454 = validateParameter(valid_594454, JString, required = false,
                                 default = nil)
  if valid_594454 != nil:
    section.add "quotaUser", valid_594454
  var valid_594455 = query.getOrDefault("alt")
  valid_594455 = validateParameter(valid_594455, JString, required = false,
                                 default = newJString("json"))
  if valid_594455 != nil:
    section.add "alt", valid_594455
  var valid_594456 = query.getOrDefault("oauth_token")
  valid_594456 = validateParameter(valid_594456, JString, required = false,
                                 default = nil)
  if valid_594456 != nil:
    section.add "oauth_token", valid_594456
  var valid_594457 = query.getOrDefault("callback")
  valid_594457 = validateParameter(valid_594457, JString, required = false,
                                 default = nil)
  if valid_594457 != nil:
    section.add "callback", valid_594457
  var valid_594458 = query.getOrDefault("access_token")
  valid_594458 = validateParameter(valid_594458, JString, required = false,
                                 default = nil)
  if valid_594458 != nil:
    section.add "access_token", valid_594458
  var valid_594459 = query.getOrDefault("uploadType")
  valid_594459 = validateParameter(valid_594459, JString, required = false,
                                 default = nil)
  if valid_594459 != nil:
    section.add "uploadType", valid_594459
  var valid_594460 = query.getOrDefault("key")
  valid_594460 = validateParameter(valid_594460, JString, required = false,
                                 default = nil)
  if valid_594460 != nil:
    section.add "key", valid_594460
  var valid_594461 = query.getOrDefault("$.xgafv")
  valid_594461 = validateParameter(valid_594461, JString, required = false,
                                 default = newJString("1"))
  if valid_594461 != nil:
    section.add "$.xgafv", valid_594461
  var valid_594462 = query.getOrDefault("prettyPrint")
  valid_594462 = validateParameter(valid_594462, JBool, required = false,
                                 default = newJBool(true))
  if valid_594462 != nil:
    section.add "prettyPrint", valid_594462
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

proc call*(call_594464: Call_DlpOrganizationsStoredInfoTypesCreate_594448;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a pre-built stored infoType to be used for inspection.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  let valid = call_594464.validator(path, query, header, formData, body)
  let scheme = call_594464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594464.url(scheme.get, call_594464.host, call_594464.base,
                         call_594464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594464, url, valid)

proc call*(call_594465: Call_DlpOrganizationsStoredInfoTypesCreate_594448;
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
  var path_594466 = newJObject()
  var query_594467 = newJObject()
  var body_594468 = newJObject()
  add(query_594467, "upload_protocol", newJString(uploadProtocol))
  add(query_594467, "fields", newJString(fields))
  add(query_594467, "quotaUser", newJString(quotaUser))
  add(query_594467, "alt", newJString(alt))
  add(query_594467, "oauth_token", newJString(oauthToken))
  add(query_594467, "callback", newJString(callback))
  add(query_594467, "access_token", newJString(accessToken))
  add(query_594467, "uploadType", newJString(uploadType))
  add(path_594466, "parent", newJString(parent))
  add(query_594467, "key", newJString(key))
  add(query_594467, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594468 = body
  add(query_594467, "prettyPrint", newJBool(prettyPrint))
  result = call_594465.call(path_594466, query_594467, nil, nil, body_594468)

var dlpOrganizationsStoredInfoTypesCreate* = Call_DlpOrganizationsStoredInfoTypesCreate_594448(
    name: "dlpOrganizationsStoredInfoTypesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2/{parent}/storedInfoTypes",
    validator: validate_DlpOrganizationsStoredInfoTypesCreate_594449, base: "/",
    url: url_DlpOrganizationsStoredInfoTypesCreate_594450, schemes: {Scheme.Https})
type
  Call_DlpOrganizationsStoredInfoTypesList_594426 = ref object of OpenApiRestCall_593421
proc url_DlpOrganizationsStoredInfoTypesList_594428(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DlpOrganizationsStoredInfoTypesList_594427(path: JsonNode;
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
  var valid_594429 = path.getOrDefault("parent")
  valid_594429 = validateParameter(valid_594429, JString, required = true,
                                 default = nil)
  if valid_594429 != nil:
    section.add "parent", valid_594429
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
  var valid_594430 = query.getOrDefault("upload_protocol")
  valid_594430 = validateParameter(valid_594430, JString, required = false,
                                 default = nil)
  if valid_594430 != nil:
    section.add "upload_protocol", valid_594430
  var valid_594431 = query.getOrDefault("fields")
  valid_594431 = validateParameter(valid_594431, JString, required = false,
                                 default = nil)
  if valid_594431 != nil:
    section.add "fields", valid_594431
  var valid_594432 = query.getOrDefault("pageToken")
  valid_594432 = validateParameter(valid_594432, JString, required = false,
                                 default = nil)
  if valid_594432 != nil:
    section.add "pageToken", valid_594432
  var valid_594433 = query.getOrDefault("quotaUser")
  valid_594433 = validateParameter(valid_594433, JString, required = false,
                                 default = nil)
  if valid_594433 != nil:
    section.add "quotaUser", valid_594433
  var valid_594434 = query.getOrDefault("alt")
  valid_594434 = validateParameter(valid_594434, JString, required = false,
                                 default = newJString("json"))
  if valid_594434 != nil:
    section.add "alt", valid_594434
  var valid_594435 = query.getOrDefault("oauth_token")
  valid_594435 = validateParameter(valid_594435, JString, required = false,
                                 default = nil)
  if valid_594435 != nil:
    section.add "oauth_token", valid_594435
  var valid_594436 = query.getOrDefault("callback")
  valid_594436 = validateParameter(valid_594436, JString, required = false,
                                 default = nil)
  if valid_594436 != nil:
    section.add "callback", valid_594436
  var valid_594437 = query.getOrDefault("access_token")
  valid_594437 = validateParameter(valid_594437, JString, required = false,
                                 default = nil)
  if valid_594437 != nil:
    section.add "access_token", valid_594437
  var valid_594438 = query.getOrDefault("uploadType")
  valid_594438 = validateParameter(valid_594438, JString, required = false,
                                 default = nil)
  if valid_594438 != nil:
    section.add "uploadType", valid_594438
  var valid_594439 = query.getOrDefault("orderBy")
  valid_594439 = validateParameter(valid_594439, JString, required = false,
                                 default = nil)
  if valid_594439 != nil:
    section.add "orderBy", valid_594439
  var valid_594440 = query.getOrDefault("key")
  valid_594440 = validateParameter(valid_594440, JString, required = false,
                                 default = nil)
  if valid_594440 != nil:
    section.add "key", valid_594440
  var valid_594441 = query.getOrDefault("$.xgafv")
  valid_594441 = validateParameter(valid_594441, JString, required = false,
                                 default = newJString("1"))
  if valid_594441 != nil:
    section.add "$.xgafv", valid_594441
  var valid_594442 = query.getOrDefault("pageSize")
  valid_594442 = validateParameter(valid_594442, JInt, required = false, default = nil)
  if valid_594442 != nil:
    section.add "pageSize", valid_594442
  var valid_594443 = query.getOrDefault("prettyPrint")
  valid_594443 = validateParameter(valid_594443, JBool, required = false,
                                 default = newJBool(true))
  if valid_594443 != nil:
    section.add "prettyPrint", valid_594443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594444: Call_DlpOrganizationsStoredInfoTypesList_594426;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists stored infoTypes.
  ## See https://cloud.google.com/dlp/docs/creating-stored-infotypes to
  ## learn more.
  ## 
  let valid = call_594444.validator(path, query, header, formData, body)
  let scheme = call_594444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594444.url(scheme.get, call_594444.host, call_594444.base,
                         call_594444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594444, url, valid)

proc call*(call_594445: Call_DlpOrganizationsStoredInfoTypesList_594426;
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
  var path_594446 = newJObject()
  var query_594447 = newJObject()
  add(query_594447, "upload_protocol", newJString(uploadProtocol))
  add(query_594447, "fields", newJString(fields))
  add(query_594447, "pageToken", newJString(pageToken))
  add(query_594447, "quotaUser", newJString(quotaUser))
  add(query_594447, "alt", newJString(alt))
  add(query_594447, "oauth_token", newJString(oauthToken))
  add(query_594447, "callback", newJString(callback))
  add(query_594447, "access_token", newJString(accessToken))
  add(query_594447, "uploadType", newJString(uploadType))
  add(path_594446, "parent", newJString(parent))
  add(query_594447, "orderBy", newJString(orderBy))
  add(query_594447, "key", newJString(key))
  add(query_594447, "$.xgafv", newJString(Xgafv))
  add(query_594447, "pageSize", newJInt(pageSize))
  add(query_594447, "prettyPrint", newJBool(prettyPrint))
  result = call_594445.call(path_594446, query_594447, nil, nil, nil)

var dlpOrganizationsStoredInfoTypesList* = Call_DlpOrganizationsStoredInfoTypesList_594426(
    name: "dlpOrganizationsStoredInfoTypesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2/{parent}/storedInfoTypes",
    validator: validate_DlpOrganizationsStoredInfoTypesList_594427, base: "/",
    url: url_DlpOrganizationsStoredInfoTypesList_594428, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
