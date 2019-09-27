
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud Data Loss Prevention (DLP)
## version: v2beta2
## termsOfService: (not provided)
## license: (not provided)
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
  ## Returns sensitive information types DLP supports.
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   languageCode: JString
  ##               : Optional BCP-47 language code for localized infoType friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional filter to only return infoTypes supported by certain parts of the
  ## API. Defaults to supported_by=INSPECT.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_593821 = query.getOrDefault("pp")
  valid_593821 = validateParameter(valid_593821, JBool, required = false,
                                 default = newJBool(true))
  if valid_593821 != nil:
    section.add "pp", valid_593821
  var valid_593822 = query.getOrDefault("oauth_token")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "oauth_token", valid_593822
  var valid_593823 = query.getOrDefault("callback")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "callback", valid_593823
  var valid_593824 = query.getOrDefault("access_token")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "access_token", valid_593824
  var valid_593825 = query.getOrDefault("uploadType")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "uploadType", valid_593825
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
  var valid_593831 = query.getOrDefault("bearer_token")
  valid_593831 = validateParameter(valid_593831, JString, required = false,
                                 default = nil)
  if valid_593831 != nil:
    section.add "bearer_token", valid_593831
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593854: Call_DlpInfoTypesList_593690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns sensitive information types DLP supports.
  ## 
  let valid = call_593854.validator(path, query, header, formData, body)
  let scheme = call_593854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593854.url(scheme.get, call_593854.host, call_593854.base,
                         call_593854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593854, url, valid)

proc call*(call_593925: Call_DlpInfoTypesList_593690; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; languageCode: string = ""; prettyPrint: bool = true;
          filter: string = ""; bearerToken: string = ""): Recallable =
  ## dlpInfoTypesList
  ## Returns sensitive information types DLP supports.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   languageCode: string
  ##               : Optional BCP-47 language code for localized infoType friendly
  ## names. If omitted, or if localized strings are not available,
  ## en-US strings will be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional filter to only return infoTypes supported by certain parts of the
  ## API. Defaults to supported_by=INSPECT.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_593926 = newJObject()
  add(query_593926, "upload_protocol", newJString(uploadProtocol))
  add(query_593926, "fields", newJString(fields))
  add(query_593926, "quotaUser", newJString(quotaUser))
  add(query_593926, "alt", newJString(alt))
  add(query_593926, "pp", newJBool(pp))
  add(query_593926, "oauth_token", newJString(oauthToken))
  add(query_593926, "callback", newJString(callback))
  add(query_593926, "access_token", newJString(accessToken))
  add(query_593926, "uploadType", newJString(uploadType))
  add(query_593926, "key", newJString(key))
  add(query_593926, "$.xgafv", newJString(Xgafv))
  add(query_593926, "languageCode", newJString(languageCode))
  add(query_593926, "prettyPrint", newJBool(prettyPrint))
  add(query_593926, "filter", newJString(filter))
  add(query_593926, "bearer_token", newJString(bearerToken))
  result = call_593925.call(nil, query_593926, nil, nil, nil)

var dlpInfoTypesList* = Call_DlpInfoTypesList_593690(name: "dlpInfoTypesList",
    meth: HttpMethod.HttpGet, host: "dlp.googleapis.com",
    route: "/v2beta2/infoTypes", validator: validate_DlpInfoTypesList_593691,
    base: "/", url: url_DlpInfoTypesList_593692, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersGet_593966 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsJobTriggersGet_593968(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersGet_593967(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a job trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the project and the triggeredJob, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593983 = path.getOrDefault("name")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "name", valid_593983
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_593984 = query.getOrDefault("upload_protocol")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "upload_protocol", valid_593984
  var valid_593985 = query.getOrDefault("fields")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "fields", valid_593985
  var valid_593986 = query.getOrDefault("quotaUser")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "quotaUser", valid_593986
  var valid_593987 = query.getOrDefault("alt")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = newJString("json"))
  if valid_593987 != nil:
    section.add "alt", valid_593987
  var valid_593988 = query.getOrDefault("pp")
  valid_593988 = validateParameter(valid_593988, JBool, required = false,
                                 default = newJBool(true))
  if valid_593988 != nil:
    section.add "pp", valid_593988
  var valid_593989 = query.getOrDefault("oauth_token")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "oauth_token", valid_593989
  var valid_593990 = query.getOrDefault("callback")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "callback", valid_593990
  var valid_593991 = query.getOrDefault("access_token")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "access_token", valid_593991
  var valid_593992 = query.getOrDefault("uploadType")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "uploadType", valid_593992
  var valid_593993 = query.getOrDefault("key")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "key", valid_593993
  var valid_593994 = query.getOrDefault("$.xgafv")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = newJString("1"))
  if valid_593994 != nil:
    section.add "$.xgafv", valid_593994
  var valid_593995 = query.getOrDefault("prettyPrint")
  valid_593995 = validateParameter(valid_593995, JBool, required = false,
                                 default = newJBool(true))
  if valid_593995 != nil:
    section.add "prettyPrint", valid_593995
  var valid_593996 = query.getOrDefault("bearer_token")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "bearer_token", valid_593996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593997: Call_DlpProjectsJobTriggersGet_593966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job trigger.
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_DlpProjectsJobTriggersGet_593966; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dlpProjectsJobTriggersGet
  ## Gets a job trigger.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the project and the triggeredJob, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_593999 = newJObject()
  var query_594000 = newJObject()
  add(query_594000, "upload_protocol", newJString(uploadProtocol))
  add(query_594000, "fields", newJString(fields))
  add(query_594000, "quotaUser", newJString(quotaUser))
  add(path_593999, "name", newJString(name))
  add(query_594000, "alt", newJString(alt))
  add(query_594000, "pp", newJBool(pp))
  add(query_594000, "oauth_token", newJString(oauthToken))
  add(query_594000, "callback", newJString(callback))
  add(query_594000, "access_token", newJString(accessToken))
  add(query_594000, "uploadType", newJString(uploadType))
  add(query_594000, "key", newJString(key))
  add(query_594000, "$.xgafv", newJString(Xgafv))
  add(query_594000, "prettyPrint", newJBool(prettyPrint))
  add(query_594000, "bearer_token", newJString(bearerToken))
  result = call_593998.call(path_593999, query_594000, nil, nil, nil)

var dlpProjectsJobTriggersGet* = Call_DlpProjectsJobTriggersGet_593966(
    name: "dlpProjectsJobTriggersGet", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta2/{name}",
    validator: validate_DlpProjectsJobTriggersGet_593967, base: "/",
    url: url_DlpProjectsJobTriggersGet_593968, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersPatch_594022 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsJobTriggersPatch_594024(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersPatch_594023(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a job trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the project and the triggeredJob, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594025 = path.getOrDefault("name")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "name", valid_594025
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_594026 = query.getOrDefault("upload_protocol")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "upload_protocol", valid_594026
  var valid_594027 = query.getOrDefault("fields")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "fields", valid_594027
  var valid_594028 = query.getOrDefault("quotaUser")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "quotaUser", valid_594028
  var valid_594029 = query.getOrDefault("alt")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = newJString("json"))
  if valid_594029 != nil:
    section.add "alt", valid_594029
  var valid_594030 = query.getOrDefault("pp")
  valid_594030 = validateParameter(valid_594030, JBool, required = false,
                                 default = newJBool(true))
  if valid_594030 != nil:
    section.add "pp", valid_594030
  var valid_594031 = query.getOrDefault("oauth_token")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "oauth_token", valid_594031
  var valid_594032 = query.getOrDefault("callback")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "callback", valid_594032
  var valid_594033 = query.getOrDefault("access_token")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "access_token", valid_594033
  var valid_594034 = query.getOrDefault("uploadType")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "uploadType", valid_594034
  var valid_594035 = query.getOrDefault("key")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "key", valid_594035
  var valid_594036 = query.getOrDefault("$.xgafv")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = newJString("1"))
  if valid_594036 != nil:
    section.add "$.xgafv", valid_594036
  var valid_594037 = query.getOrDefault("prettyPrint")
  valid_594037 = validateParameter(valid_594037, JBool, required = false,
                                 default = newJBool(true))
  if valid_594037 != nil:
    section.add "prettyPrint", valid_594037
  var valid_594038 = query.getOrDefault("bearer_token")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "bearer_token", valid_594038
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

proc call*(call_594040: Call_DlpProjectsJobTriggersPatch_594022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a job trigger.
  ## 
  let valid = call_594040.validator(path, query, header, formData, body)
  let scheme = call_594040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594040.url(scheme.get, call_594040.host, call_594040.base,
                         call_594040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594040, url, valid)

proc call*(call_594041: Call_DlpProjectsJobTriggersPatch_594022; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsJobTriggersPatch
  ## Updates a job trigger.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the project and the triggeredJob, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_594042 = newJObject()
  var query_594043 = newJObject()
  var body_594044 = newJObject()
  add(query_594043, "upload_protocol", newJString(uploadProtocol))
  add(query_594043, "fields", newJString(fields))
  add(query_594043, "quotaUser", newJString(quotaUser))
  add(path_594042, "name", newJString(name))
  add(query_594043, "alt", newJString(alt))
  add(query_594043, "pp", newJBool(pp))
  add(query_594043, "oauth_token", newJString(oauthToken))
  add(query_594043, "callback", newJString(callback))
  add(query_594043, "access_token", newJString(accessToken))
  add(query_594043, "uploadType", newJString(uploadType))
  add(query_594043, "key", newJString(key))
  add(query_594043, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594044 = body
  add(query_594043, "prettyPrint", newJBool(prettyPrint))
  add(query_594043, "bearer_token", newJString(bearerToken))
  result = call_594041.call(path_594042, query_594043, nil, nil, body_594044)

var dlpProjectsJobTriggersPatch* = Call_DlpProjectsJobTriggersPatch_594022(
    name: "dlpProjectsJobTriggersPatch", meth: HttpMethod.HttpPatch,
    host: "dlp.googleapis.com", route: "/v2beta2/{name}",
    validator: validate_DlpProjectsJobTriggersPatch_594023, base: "/",
    url: url_DlpProjectsJobTriggersPatch_594024, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersDelete_594001 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsJobTriggersDelete_594003(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersDelete_594002(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a job trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the project and the triggeredJob, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594004 = path.getOrDefault("name")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "name", valid_594004
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_594005 = query.getOrDefault("upload_protocol")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "upload_protocol", valid_594005
  var valid_594006 = query.getOrDefault("fields")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "fields", valid_594006
  var valid_594007 = query.getOrDefault("quotaUser")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "quotaUser", valid_594007
  var valid_594008 = query.getOrDefault("alt")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = newJString("json"))
  if valid_594008 != nil:
    section.add "alt", valid_594008
  var valid_594009 = query.getOrDefault("pp")
  valid_594009 = validateParameter(valid_594009, JBool, required = false,
                                 default = newJBool(true))
  if valid_594009 != nil:
    section.add "pp", valid_594009
  var valid_594010 = query.getOrDefault("oauth_token")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "oauth_token", valid_594010
  var valid_594011 = query.getOrDefault("callback")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "callback", valid_594011
  var valid_594012 = query.getOrDefault("access_token")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "access_token", valid_594012
  var valid_594013 = query.getOrDefault("uploadType")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "uploadType", valid_594013
  var valid_594014 = query.getOrDefault("key")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "key", valid_594014
  var valid_594015 = query.getOrDefault("$.xgafv")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = newJString("1"))
  if valid_594015 != nil:
    section.add "$.xgafv", valid_594015
  var valid_594016 = query.getOrDefault("prettyPrint")
  valid_594016 = validateParameter(valid_594016, JBool, required = false,
                                 default = newJBool(true))
  if valid_594016 != nil:
    section.add "prettyPrint", valid_594016
  var valid_594017 = query.getOrDefault("bearer_token")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "bearer_token", valid_594017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594018: Call_DlpProjectsJobTriggersDelete_594001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job trigger.
  ## 
  let valid = call_594018.validator(path, query, header, formData, body)
  let scheme = call_594018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594018.url(scheme.get, call_594018.host, call_594018.base,
                         call_594018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594018, url, valid)

proc call*(call_594019: Call_DlpProjectsJobTriggersDelete_594001; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dlpProjectsJobTriggersDelete
  ## Deletes a job trigger.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the project and the triggeredJob, for example
  ## `projects/dlp-test-project/jobTriggers/53234423`.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_594020 = newJObject()
  var query_594021 = newJObject()
  add(query_594021, "upload_protocol", newJString(uploadProtocol))
  add(query_594021, "fields", newJString(fields))
  add(query_594021, "quotaUser", newJString(quotaUser))
  add(path_594020, "name", newJString(name))
  add(query_594021, "alt", newJString(alt))
  add(query_594021, "pp", newJBool(pp))
  add(query_594021, "oauth_token", newJString(oauthToken))
  add(query_594021, "callback", newJString(callback))
  add(query_594021, "access_token", newJString(accessToken))
  add(query_594021, "uploadType", newJString(uploadType))
  add(query_594021, "key", newJString(key))
  add(query_594021, "$.xgafv", newJString(Xgafv))
  add(query_594021, "prettyPrint", newJBool(prettyPrint))
  add(query_594021, "bearer_token", newJString(bearerToken))
  result = call_594019.call(path_594020, query_594021, nil, nil, nil)

var dlpProjectsJobTriggersDelete* = Call_DlpProjectsJobTriggersDelete_594001(
    name: "dlpProjectsJobTriggersDelete", meth: HttpMethod.HttpDelete,
    host: "dlp.googleapis.com", route: "/v2beta2/{name}",
    validator: validate_DlpProjectsJobTriggersDelete_594002, base: "/",
    url: url_DlpProjectsJobTriggersDelete_594003, schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsCancel_594045 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsDlpJobsCancel_594047(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsDlpJobsCancel_594046(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running DlpJob.  The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the DlpJob resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594048 = path.getOrDefault("name")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "name", valid_594048
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_594049 = query.getOrDefault("upload_protocol")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "upload_protocol", valid_594049
  var valid_594050 = query.getOrDefault("fields")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "fields", valid_594050
  var valid_594051 = query.getOrDefault("quotaUser")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "quotaUser", valid_594051
  var valid_594052 = query.getOrDefault("alt")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = newJString("json"))
  if valid_594052 != nil:
    section.add "alt", valid_594052
  var valid_594053 = query.getOrDefault("pp")
  valid_594053 = validateParameter(valid_594053, JBool, required = false,
                                 default = newJBool(true))
  if valid_594053 != nil:
    section.add "pp", valid_594053
  var valid_594054 = query.getOrDefault("oauth_token")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "oauth_token", valid_594054
  var valid_594055 = query.getOrDefault("callback")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "callback", valid_594055
  var valid_594056 = query.getOrDefault("access_token")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "access_token", valid_594056
  var valid_594057 = query.getOrDefault("uploadType")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "uploadType", valid_594057
  var valid_594058 = query.getOrDefault("key")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "key", valid_594058
  var valid_594059 = query.getOrDefault("$.xgafv")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = newJString("1"))
  if valid_594059 != nil:
    section.add "$.xgafv", valid_594059
  var valid_594060 = query.getOrDefault("prettyPrint")
  valid_594060 = validateParameter(valid_594060, JBool, required = false,
                                 default = newJBool(true))
  if valid_594060 != nil:
    section.add "prettyPrint", valid_594060
  var valid_594061 = query.getOrDefault("bearer_token")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "bearer_token", valid_594061
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

proc call*(call_594063: Call_DlpProjectsDlpJobsCancel_594045; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running DlpJob.  The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
  ## 
  let valid = call_594063.validator(path, query, header, formData, body)
  let scheme = call_594063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594063.url(scheme.get, call_594063.host, call_594063.base,
                         call_594063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594063, url, valid)

proc call*(call_594064: Call_DlpProjectsDlpJobsCancel_594045; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsDlpJobsCancel
  ## Starts asynchronous cancellation on a long-running DlpJob.  The server
  ## makes a best effort to cancel the DlpJob, but success is not
  ## guaranteed.
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
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_594065 = newJObject()
  var query_594066 = newJObject()
  var body_594067 = newJObject()
  add(query_594066, "upload_protocol", newJString(uploadProtocol))
  add(query_594066, "fields", newJString(fields))
  add(query_594066, "quotaUser", newJString(quotaUser))
  add(path_594065, "name", newJString(name))
  add(query_594066, "alt", newJString(alt))
  add(query_594066, "pp", newJBool(pp))
  add(query_594066, "oauth_token", newJString(oauthToken))
  add(query_594066, "callback", newJString(callback))
  add(query_594066, "access_token", newJString(accessToken))
  add(query_594066, "uploadType", newJString(uploadType))
  add(query_594066, "key", newJString(key))
  add(query_594066, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594067 = body
  add(query_594066, "prettyPrint", newJBool(prettyPrint))
  add(query_594066, "bearer_token", newJString(bearerToken))
  result = call_594064.call(path_594065, query_594066, nil, nil, body_594067)

var dlpProjectsDlpJobsCancel* = Call_DlpProjectsDlpJobsCancel_594045(
    name: "dlpProjectsDlpJobsCancel", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{name}:cancel",
    validator: validate_DlpProjectsDlpJobsCancel_594046, base: "/",
    url: url_DlpProjectsDlpJobsCancel_594047, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentDeidentify_594068 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsContentDeidentify_594070(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/content:deidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsContentDeidentify_594069(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## [How-to guide](/dlp/docs/deidentify-sensitive-data)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594071 = path.getOrDefault("parent")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "parent", valid_594071
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_594072 = query.getOrDefault("upload_protocol")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "upload_protocol", valid_594072
  var valid_594073 = query.getOrDefault("fields")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "fields", valid_594073
  var valid_594074 = query.getOrDefault("quotaUser")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "quotaUser", valid_594074
  var valid_594075 = query.getOrDefault("alt")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = newJString("json"))
  if valid_594075 != nil:
    section.add "alt", valid_594075
  var valid_594076 = query.getOrDefault("pp")
  valid_594076 = validateParameter(valid_594076, JBool, required = false,
                                 default = newJBool(true))
  if valid_594076 != nil:
    section.add "pp", valid_594076
  var valid_594077 = query.getOrDefault("oauth_token")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "oauth_token", valid_594077
  var valid_594078 = query.getOrDefault("callback")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "callback", valid_594078
  var valid_594079 = query.getOrDefault("access_token")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "access_token", valid_594079
  var valid_594080 = query.getOrDefault("uploadType")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "uploadType", valid_594080
  var valid_594081 = query.getOrDefault("key")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "key", valid_594081
  var valid_594082 = query.getOrDefault("$.xgafv")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = newJString("1"))
  if valid_594082 != nil:
    section.add "$.xgafv", valid_594082
  var valid_594083 = query.getOrDefault("prettyPrint")
  valid_594083 = validateParameter(valid_594083, JBool, required = false,
                                 default = newJBool(true))
  if valid_594083 != nil:
    section.add "prettyPrint", valid_594083
  var valid_594084 = query.getOrDefault("bearer_token")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "bearer_token", valid_594084
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

proc call*(call_594086: Call_DlpProjectsContentDeidentify_594068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## [How-to guide](/dlp/docs/deidentify-sensitive-data)
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_DlpProjectsContentDeidentify_594068; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsContentDeidentify
  ## De-identifies potentially sensitive info from a ContentItem.
  ## This method has limits on input size and output size.
  ## [How-to guide](/dlp/docs/deidentify-sensitive-data)
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  var body_594090 = newJObject()
  add(query_594089, "upload_protocol", newJString(uploadProtocol))
  add(query_594089, "fields", newJString(fields))
  add(query_594089, "quotaUser", newJString(quotaUser))
  add(query_594089, "alt", newJString(alt))
  add(query_594089, "pp", newJBool(pp))
  add(query_594089, "oauth_token", newJString(oauthToken))
  add(query_594089, "callback", newJString(callback))
  add(query_594089, "access_token", newJString(accessToken))
  add(query_594089, "uploadType", newJString(uploadType))
  add(path_594088, "parent", newJString(parent))
  add(query_594089, "key", newJString(key))
  add(query_594089, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594090 = body
  add(query_594089, "prettyPrint", newJBool(prettyPrint))
  add(query_594089, "bearer_token", newJString(bearerToken))
  result = call_594087.call(path_594088, query_594089, nil, nil, body_594090)

var dlpProjectsContentDeidentify* = Call_DlpProjectsContentDeidentify_594068(
    name: "dlpProjectsContentDeidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/content:deidentify",
    validator: validate_DlpProjectsContentDeidentify_594069, base: "/",
    url: url_DlpProjectsContentDeidentify_594070, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentInspect_594091 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsContentInspect_594093(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/content:inspect")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsContentInspect_594092(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## [How-to guide for text](/dlp/docs/inspecting-text), [How-to guide for
  ## images](/dlp/docs/inspecting-images)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594094 = path.getOrDefault("parent")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "parent", valid_594094
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_594095 = query.getOrDefault("upload_protocol")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "upload_protocol", valid_594095
  var valid_594096 = query.getOrDefault("fields")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "fields", valid_594096
  var valid_594097 = query.getOrDefault("quotaUser")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "quotaUser", valid_594097
  var valid_594098 = query.getOrDefault("alt")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = newJString("json"))
  if valid_594098 != nil:
    section.add "alt", valid_594098
  var valid_594099 = query.getOrDefault("pp")
  valid_594099 = validateParameter(valid_594099, JBool, required = false,
                                 default = newJBool(true))
  if valid_594099 != nil:
    section.add "pp", valid_594099
  var valid_594100 = query.getOrDefault("oauth_token")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "oauth_token", valid_594100
  var valid_594101 = query.getOrDefault("callback")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "callback", valid_594101
  var valid_594102 = query.getOrDefault("access_token")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "access_token", valid_594102
  var valid_594103 = query.getOrDefault("uploadType")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "uploadType", valid_594103
  var valid_594104 = query.getOrDefault("key")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "key", valid_594104
  var valid_594105 = query.getOrDefault("$.xgafv")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = newJString("1"))
  if valid_594105 != nil:
    section.add "$.xgafv", valid_594105
  var valid_594106 = query.getOrDefault("prettyPrint")
  valid_594106 = validateParameter(valid_594106, JBool, required = false,
                                 default = newJBool(true))
  if valid_594106 != nil:
    section.add "prettyPrint", valid_594106
  var valid_594107 = query.getOrDefault("bearer_token")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "bearer_token", valid_594107
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

proc call*(call_594109: Call_DlpProjectsContentInspect_594091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## [How-to guide for text](/dlp/docs/inspecting-text), [How-to guide for
  ## images](/dlp/docs/inspecting-images)
  ## 
  let valid = call_594109.validator(path, query, header, formData, body)
  let scheme = call_594109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594109.url(scheme.get, call_594109.host, call_594109.base,
                         call_594109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594109, url, valid)

proc call*(call_594110: Call_DlpProjectsContentInspect_594091; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsContentInspect
  ## Finds potentially sensitive info in content.
  ## This method has limits on input size, processing time, and output size.
  ## [How-to guide for text](/dlp/docs/inspecting-text), [How-to guide for
  ## images](/dlp/docs/inspecting-images)
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_594111 = newJObject()
  var query_594112 = newJObject()
  var body_594113 = newJObject()
  add(query_594112, "upload_protocol", newJString(uploadProtocol))
  add(query_594112, "fields", newJString(fields))
  add(query_594112, "quotaUser", newJString(quotaUser))
  add(query_594112, "alt", newJString(alt))
  add(query_594112, "pp", newJBool(pp))
  add(query_594112, "oauth_token", newJString(oauthToken))
  add(query_594112, "callback", newJString(callback))
  add(query_594112, "access_token", newJString(accessToken))
  add(query_594112, "uploadType", newJString(uploadType))
  add(path_594111, "parent", newJString(parent))
  add(query_594112, "key", newJString(key))
  add(query_594112, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594113 = body
  add(query_594112, "prettyPrint", newJBool(prettyPrint))
  add(query_594112, "bearer_token", newJString(bearerToken))
  result = call_594110.call(path_594111, query_594112, nil, nil, body_594113)

var dlpProjectsContentInspect* = Call_DlpProjectsContentInspect_594091(
    name: "dlpProjectsContentInspect", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/content:inspect",
    validator: validate_DlpProjectsContentInspect_594092, base: "/",
    url: url_DlpProjectsContentInspect_594093, schemes: {Scheme.Https})
type
  Call_DlpProjectsContentReidentify_594114 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsContentReidentify_594116(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/content:reidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsContentReidentify_594115(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Re-identify content that has been de-identified.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594117 = path.getOrDefault("parent")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "parent", valid_594117
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_594118 = query.getOrDefault("upload_protocol")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "upload_protocol", valid_594118
  var valid_594119 = query.getOrDefault("fields")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "fields", valid_594119
  var valid_594120 = query.getOrDefault("quotaUser")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "quotaUser", valid_594120
  var valid_594121 = query.getOrDefault("alt")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = newJString("json"))
  if valid_594121 != nil:
    section.add "alt", valid_594121
  var valid_594122 = query.getOrDefault("pp")
  valid_594122 = validateParameter(valid_594122, JBool, required = false,
                                 default = newJBool(true))
  if valid_594122 != nil:
    section.add "pp", valid_594122
  var valid_594123 = query.getOrDefault("oauth_token")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "oauth_token", valid_594123
  var valid_594124 = query.getOrDefault("callback")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "callback", valid_594124
  var valid_594125 = query.getOrDefault("access_token")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "access_token", valid_594125
  var valid_594126 = query.getOrDefault("uploadType")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "uploadType", valid_594126
  var valid_594127 = query.getOrDefault("key")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "key", valid_594127
  var valid_594128 = query.getOrDefault("$.xgafv")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = newJString("1"))
  if valid_594128 != nil:
    section.add "$.xgafv", valid_594128
  var valid_594129 = query.getOrDefault("prettyPrint")
  valid_594129 = validateParameter(valid_594129, JBool, required = false,
                                 default = newJBool(true))
  if valid_594129 != nil:
    section.add "prettyPrint", valid_594129
  var valid_594130 = query.getOrDefault("bearer_token")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "bearer_token", valid_594130
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

proc call*(call_594132: Call_DlpProjectsContentReidentify_594114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Re-identify content that has been de-identified.
  ## 
  let valid = call_594132.validator(path, query, header, formData, body)
  let scheme = call_594132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594132.url(scheme.get, call_594132.host, call_594132.base,
                         call_594132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594132, url, valid)

proc call*(call_594133: Call_DlpProjectsContentReidentify_594114; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsContentReidentify
  ## Re-identify content that has been de-identified.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_594134 = newJObject()
  var query_594135 = newJObject()
  var body_594136 = newJObject()
  add(query_594135, "upload_protocol", newJString(uploadProtocol))
  add(query_594135, "fields", newJString(fields))
  add(query_594135, "quotaUser", newJString(quotaUser))
  add(query_594135, "alt", newJString(alt))
  add(query_594135, "pp", newJBool(pp))
  add(query_594135, "oauth_token", newJString(oauthToken))
  add(query_594135, "callback", newJString(callback))
  add(query_594135, "access_token", newJString(accessToken))
  add(query_594135, "uploadType", newJString(uploadType))
  add(path_594134, "parent", newJString(parent))
  add(query_594135, "key", newJString(key))
  add(query_594135, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594136 = body
  add(query_594135, "prettyPrint", newJBool(prettyPrint))
  add(query_594135, "bearer_token", newJString(bearerToken))
  result = call_594133.call(path_594134, query_594135, nil, nil, body_594136)

var dlpProjectsContentReidentify* = Call_DlpProjectsContentReidentify_594114(
    name: "dlpProjectsContentReidentify", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/content:reidentify",
    validator: validate_DlpProjectsContentReidentify_594115, base: "/",
    url: url_DlpProjectsContentReidentify_594116, schemes: {Scheme.Https})
type
  Call_DlpProjectsDataSourceAnalyze_594137 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsDataSourceAnalyze_594139(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dataSource:analyze")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsDataSourceAnalyze_594138(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Schedules a job to compute risk analysis metrics over content in a Google
  ## Cloud Platform repository. [How-to guide](/dlp/docs/compute-risk-analysis)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594140 = path.getOrDefault("parent")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "parent", valid_594140
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_594141 = query.getOrDefault("upload_protocol")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "upload_protocol", valid_594141
  var valid_594142 = query.getOrDefault("fields")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "fields", valid_594142
  var valid_594143 = query.getOrDefault("quotaUser")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "quotaUser", valid_594143
  var valid_594144 = query.getOrDefault("alt")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = newJString("json"))
  if valid_594144 != nil:
    section.add "alt", valid_594144
  var valid_594145 = query.getOrDefault("pp")
  valid_594145 = validateParameter(valid_594145, JBool, required = false,
                                 default = newJBool(true))
  if valid_594145 != nil:
    section.add "pp", valid_594145
  var valid_594146 = query.getOrDefault("oauth_token")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "oauth_token", valid_594146
  var valid_594147 = query.getOrDefault("callback")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "callback", valid_594147
  var valid_594148 = query.getOrDefault("access_token")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "access_token", valid_594148
  var valid_594149 = query.getOrDefault("uploadType")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "uploadType", valid_594149
  var valid_594150 = query.getOrDefault("key")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "key", valid_594150
  var valid_594151 = query.getOrDefault("$.xgafv")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = newJString("1"))
  if valid_594151 != nil:
    section.add "$.xgafv", valid_594151
  var valid_594152 = query.getOrDefault("prettyPrint")
  valid_594152 = validateParameter(valid_594152, JBool, required = false,
                                 default = newJBool(true))
  if valid_594152 != nil:
    section.add "prettyPrint", valid_594152
  var valid_594153 = query.getOrDefault("bearer_token")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "bearer_token", valid_594153
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

proc call*(call_594155: Call_DlpProjectsDataSourceAnalyze_594137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Schedules a job to compute risk analysis metrics over content in a Google
  ## Cloud Platform repository. [How-to guide](/dlp/docs/compute-risk-analysis)
  ## 
  let valid = call_594155.validator(path, query, header, formData, body)
  let scheme = call_594155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594155.url(scheme.get, call_594155.host, call_594155.base,
                         call_594155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594155, url, valid)

proc call*(call_594156: Call_DlpProjectsDataSourceAnalyze_594137; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsDataSourceAnalyze
  ## Schedules a job to compute risk analysis metrics over content in a Google
  ## Cloud Platform repository. [How-to guide](/dlp/docs/compute-risk-analysis)
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_594157 = newJObject()
  var query_594158 = newJObject()
  var body_594159 = newJObject()
  add(query_594158, "upload_protocol", newJString(uploadProtocol))
  add(query_594158, "fields", newJString(fields))
  add(query_594158, "quotaUser", newJString(quotaUser))
  add(query_594158, "alt", newJString(alt))
  add(query_594158, "pp", newJBool(pp))
  add(query_594158, "oauth_token", newJString(oauthToken))
  add(query_594158, "callback", newJString(callback))
  add(query_594158, "access_token", newJString(accessToken))
  add(query_594158, "uploadType", newJString(uploadType))
  add(path_594157, "parent", newJString(parent))
  add(query_594158, "key", newJString(key))
  add(query_594158, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594159 = body
  add(query_594158, "prettyPrint", newJBool(prettyPrint))
  add(query_594158, "bearer_token", newJString(bearerToken))
  result = call_594156.call(path_594157, query_594158, nil, nil, body_594159)

var dlpProjectsDataSourceAnalyze* = Call_DlpProjectsDataSourceAnalyze_594137(
    name: "dlpProjectsDataSourceAnalyze", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/dataSource:analyze",
    validator: validate_DlpProjectsDataSourceAnalyze_594138, base: "/",
    url: url_DlpProjectsDataSourceAnalyze_594139, schemes: {Scheme.Https})
type
  Call_DlpProjectsDataSourceInspect_594160 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsDataSourceInspect_594162(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dataSource:inspect")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsDataSourceInspect_594161(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Schedules a job scanning content in a Google Cloud Platform data
  ## repository. [How-to guide](/dlp/docs/inspecting-storage)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594163 = path.getOrDefault("parent")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "parent", valid_594163
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_594164 = query.getOrDefault("upload_protocol")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = nil)
  if valid_594164 != nil:
    section.add "upload_protocol", valid_594164
  var valid_594165 = query.getOrDefault("fields")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "fields", valid_594165
  var valid_594166 = query.getOrDefault("quotaUser")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "quotaUser", valid_594166
  var valid_594167 = query.getOrDefault("alt")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = newJString("json"))
  if valid_594167 != nil:
    section.add "alt", valid_594167
  var valid_594168 = query.getOrDefault("pp")
  valid_594168 = validateParameter(valid_594168, JBool, required = false,
                                 default = newJBool(true))
  if valid_594168 != nil:
    section.add "pp", valid_594168
  var valid_594169 = query.getOrDefault("oauth_token")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "oauth_token", valid_594169
  var valid_594170 = query.getOrDefault("callback")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "callback", valid_594170
  var valid_594171 = query.getOrDefault("access_token")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "access_token", valid_594171
  var valid_594172 = query.getOrDefault("uploadType")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "uploadType", valid_594172
  var valid_594173 = query.getOrDefault("key")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = nil)
  if valid_594173 != nil:
    section.add "key", valid_594173
  var valid_594174 = query.getOrDefault("$.xgafv")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = newJString("1"))
  if valid_594174 != nil:
    section.add "$.xgafv", valid_594174
  var valid_594175 = query.getOrDefault("prettyPrint")
  valid_594175 = validateParameter(valid_594175, JBool, required = false,
                                 default = newJBool(true))
  if valid_594175 != nil:
    section.add "prettyPrint", valid_594175
  var valid_594176 = query.getOrDefault("bearer_token")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = nil)
  if valid_594176 != nil:
    section.add "bearer_token", valid_594176
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

proc call*(call_594178: Call_DlpProjectsDataSourceInspect_594160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Schedules a job scanning content in a Google Cloud Platform data
  ## repository. [How-to guide](/dlp/docs/inspecting-storage)
  ## 
  let valid = call_594178.validator(path, query, header, formData, body)
  let scheme = call_594178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594178.url(scheme.get, call_594178.host, call_594178.base,
                         call_594178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594178, url, valid)

proc call*(call_594179: Call_DlpProjectsDataSourceInspect_594160; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsDataSourceInspect
  ## Schedules a job scanning content in a Google Cloud Platform data
  ## repository. [How-to guide](/dlp/docs/inspecting-storage)
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_594180 = newJObject()
  var query_594181 = newJObject()
  var body_594182 = newJObject()
  add(query_594181, "upload_protocol", newJString(uploadProtocol))
  add(query_594181, "fields", newJString(fields))
  add(query_594181, "quotaUser", newJString(quotaUser))
  add(query_594181, "alt", newJString(alt))
  add(query_594181, "pp", newJBool(pp))
  add(query_594181, "oauth_token", newJString(oauthToken))
  add(query_594181, "callback", newJString(callback))
  add(query_594181, "access_token", newJString(accessToken))
  add(query_594181, "uploadType", newJString(uploadType))
  add(path_594180, "parent", newJString(parent))
  add(query_594181, "key", newJString(key))
  add(query_594181, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594182 = body
  add(query_594181, "prettyPrint", newJBool(prettyPrint))
  add(query_594181, "bearer_token", newJString(bearerToken))
  result = call_594179.call(path_594180, query_594181, nil, nil, body_594182)

var dlpProjectsDataSourceInspect* = Call_DlpProjectsDataSourceInspect_594160(
    name: "dlpProjectsDataSourceInspect", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/dataSource:inspect",
    validator: validate_DlpProjectsDataSourceInspect_594161, base: "/",
    url: url_DlpProjectsDataSourceInspect_594162, schemes: {Scheme.Https})
type
  Call_DlpProjectsDeidentifyTemplatesCreate_594206 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsDeidentifyTemplatesCreate_594208(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/deidentifyTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsDeidentifyTemplatesCreate_594207(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an Deidentify template for re-using frequently used configuration
  ## for Deidentifying content, images, and storage.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594209 = path.getOrDefault("parent")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "parent", valid_594209
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_594210 = query.getOrDefault("upload_protocol")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "upload_protocol", valid_594210
  var valid_594211 = query.getOrDefault("fields")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "fields", valid_594211
  var valid_594212 = query.getOrDefault("quotaUser")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "quotaUser", valid_594212
  var valid_594213 = query.getOrDefault("alt")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = newJString("json"))
  if valid_594213 != nil:
    section.add "alt", valid_594213
  var valid_594214 = query.getOrDefault("pp")
  valid_594214 = validateParameter(valid_594214, JBool, required = false,
                                 default = newJBool(true))
  if valid_594214 != nil:
    section.add "pp", valid_594214
  var valid_594215 = query.getOrDefault("oauth_token")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "oauth_token", valid_594215
  var valid_594216 = query.getOrDefault("callback")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "callback", valid_594216
  var valid_594217 = query.getOrDefault("access_token")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "access_token", valid_594217
  var valid_594218 = query.getOrDefault("uploadType")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "uploadType", valid_594218
  var valid_594219 = query.getOrDefault("key")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "key", valid_594219
  var valid_594220 = query.getOrDefault("$.xgafv")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = newJString("1"))
  if valid_594220 != nil:
    section.add "$.xgafv", valid_594220
  var valid_594221 = query.getOrDefault("prettyPrint")
  valid_594221 = validateParameter(valid_594221, JBool, required = false,
                                 default = newJBool(true))
  if valid_594221 != nil:
    section.add "prettyPrint", valid_594221
  var valid_594222 = query.getOrDefault("bearer_token")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "bearer_token", valid_594222
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

proc call*(call_594224: Call_DlpProjectsDeidentifyTemplatesCreate_594206;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an Deidentify template for re-using frequently used configuration
  ## for Deidentifying content, images, and storage.
  ## 
  let valid = call_594224.validator(path, query, header, formData, body)
  let scheme = call_594224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594224.url(scheme.get, call_594224.host, call_594224.base,
                         call_594224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594224, url, valid)

proc call*(call_594225: Call_DlpProjectsDeidentifyTemplatesCreate_594206;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsDeidentifyTemplatesCreate
  ## Creates an Deidentify template for re-using frequently used configuration
  ## for Deidentifying content, images, and storage.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_594226 = newJObject()
  var query_594227 = newJObject()
  var body_594228 = newJObject()
  add(query_594227, "upload_protocol", newJString(uploadProtocol))
  add(query_594227, "fields", newJString(fields))
  add(query_594227, "quotaUser", newJString(quotaUser))
  add(query_594227, "alt", newJString(alt))
  add(query_594227, "pp", newJBool(pp))
  add(query_594227, "oauth_token", newJString(oauthToken))
  add(query_594227, "callback", newJString(callback))
  add(query_594227, "access_token", newJString(accessToken))
  add(query_594227, "uploadType", newJString(uploadType))
  add(path_594226, "parent", newJString(parent))
  add(query_594227, "key", newJString(key))
  add(query_594227, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594228 = body
  add(query_594227, "prettyPrint", newJBool(prettyPrint))
  add(query_594227, "bearer_token", newJString(bearerToken))
  result = call_594225.call(path_594226, query_594227, nil, nil, body_594228)

var dlpProjectsDeidentifyTemplatesCreate* = Call_DlpProjectsDeidentifyTemplatesCreate_594206(
    name: "dlpProjectsDeidentifyTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/deidentifyTemplates",
    validator: validate_DlpProjectsDeidentifyTemplatesCreate_594207, base: "/",
    url: url_DlpProjectsDeidentifyTemplatesCreate_594208, schemes: {Scheme.Https})
type
  Call_DlpProjectsDeidentifyTemplatesList_594183 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsDeidentifyTemplatesList_594185(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/deidentifyTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsDeidentifyTemplatesList_594184(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists inspect templates.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594186 = path.getOrDefault("parent")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "parent", valid_594186
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_594187 = query.getOrDefault("upload_protocol")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "upload_protocol", valid_594187
  var valid_594188 = query.getOrDefault("fields")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "fields", valid_594188
  var valid_594189 = query.getOrDefault("pageToken")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "pageToken", valid_594189
  var valid_594190 = query.getOrDefault("quotaUser")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "quotaUser", valid_594190
  var valid_594191 = query.getOrDefault("alt")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = newJString("json"))
  if valid_594191 != nil:
    section.add "alt", valid_594191
  var valid_594192 = query.getOrDefault("pp")
  valid_594192 = validateParameter(valid_594192, JBool, required = false,
                                 default = newJBool(true))
  if valid_594192 != nil:
    section.add "pp", valid_594192
  var valid_594193 = query.getOrDefault("oauth_token")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "oauth_token", valid_594193
  var valid_594194 = query.getOrDefault("callback")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "callback", valid_594194
  var valid_594195 = query.getOrDefault("access_token")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "access_token", valid_594195
  var valid_594196 = query.getOrDefault("uploadType")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = nil)
  if valid_594196 != nil:
    section.add "uploadType", valid_594196
  var valid_594197 = query.getOrDefault("key")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "key", valid_594197
  var valid_594198 = query.getOrDefault("$.xgafv")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = newJString("1"))
  if valid_594198 != nil:
    section.add "$.xgafv", valid_594198
  var valid_594199 = query.getOrDefault("pageSize")
  valid_594199 = validateParameter(valid_594199, JInt, required = false, default = nil)
  if valid_594199 != nil:
    section.add "pageSize", valid_594199
  var valid_594200 = query.getOrDefault("prettyPrint")
  valid_594200 = validateParameter(valid_594200, JBool, required = false,
                                 default = newJBool(true))
  if valid_594200 != nil:
    section.add "prettyPrint", valid_594200
  var valid_594201 = query.getOrDefault("bearer_token")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "bearer_token", valid_594201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594202: Call_DlpProjectsDeidentifyTemplatesList_594183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists inspect templates.
  ## 
  let valid = call_594202.validator(path, query, header, formData, body)
  let scheme = call_594202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594202.url(scheme.get, call_594202.host, call_594202.base,
                         call_594202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594202, url, valid)

proc call*(call_594203: Call_DlpProjectsDeidentifyTemplatesList_594183;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dlpProjectsDeidentifyTemplatesList
  ## Lists inspect templates.
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
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_594204 = newJObject()
  var query_594205 = newJObject()
  add(query_594205, "upload_protocol", newJString(uploadProtocol))
  add(query_594205, "fields", newJString(fields))
  add(query_594205, "pageToken", newJString(pageToken))
  add(query_594205, "quotaUser", newJString(quotaUser))
  add(query_594205, "alt", newJString(alt))
  add(query_594205, "pp", newJBool(pp))
  add(query_594205, "oauth_token", newJString(oauthToken))
  add(query_594205, "callback", newJString(callback))
  add(query_594205, "access_token", newJString(accessToken))
  add(query_594205, "uploadType", newJString(uploadType))
  add(path_594204, "parent", newJString(parent))
  add(query_594205, "key", newJString(key))
  add(query_594205, "$.xgafv", newJString(Xgafv))
  add(query_594205, "pageSize", newJInt(pageSize))
  add(query_594205, "prettyPrint", newJBool(prettyPrint))
  add(query_594205, "bearer_token", newJString(bearerToken))
  result = call_594203.call(path_594204, query_594205, nil, nil, nil)

var dlpProjectsDeidentifyTemplatesList* = Call_DlpProjectsDeidentifyTemplatesList_594183(
    name: "dlpProjectsDeidentifyTemplatesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/deidentifyTemplates",
    validator: validate_DlpProjectsDeidentifyTemplatesList_594184, base: "/",
    url: url_DlpProjectsDeidentifyTemplatesList_594185, schemes: {Scheme.Https})
type
  Call_DlpProjectsDlpJobsList_594229 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsDlpJobsList_594231(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dlpJobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsDlpJobsList_594230(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists DlpJobs that match the specified filter in the request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594232 = path.getOrDefault("parent")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "parent", valid_594232
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ## * Supported fields for risk analysis jobs:
  ##     - `state` - RUNNING|CANCELED|FINISHED|FAILED
  ## * The operator must be `=` or `!=`.
  ## 
  ## Examples:
  ## 
  ## * inspected_storage = cloud_storage AND state = done
  ## * inspected_storage = cloud_storage OR inspected_storage = bigquery
  ## * inspected_storage = cloud_storage AND (state = done OR state = canceled)
  ## 
  ## The length of this field should be no more than 500 characters.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_594233 = query.getOrDefault("upload_protocol")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "upload_protocol", valid_594233
  var valid_594234 = query.getOrDefault("fields")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "fields", valid_594234
  var valid_594235 = query.getOrDefault("pageToken")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "pageToken", valid_594235
  var valid_594236 = query.getOrDefault("quotaUser")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "quotaUser", valid_594236
  var valid_594237 = query.getOrDefault("alt")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = newJString("json"))
  if valid_594237 != nil:
    section.add "alt", valid_594237
  var valid_594238 = query.getOrDefault("pp")
  valid_594238 = validateParameter(valid_594238, JBool, required = false,
                                 default = newJBool(true))
  if valid_594238 != nil:
    section.add "pp", valid_594238
  var valid_594239 = query.getOrDefault("type")
  valid_594239 = validateParameter(valid_594239, JString, required = false, default = newJString(
      "DLP_JOB_TYPE_UNSPECIFIED"))
  if valid_594239 != nil:
    section.add "type", valid_594239
  var valid_594240 = query.getOrDefault("oauth_token")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "oauth_token", valid_594240
  var valid_594241 = query.getOrDefault("callback")
  valid_594241 = validateParameter(valid_594241, JString, required = false,
                                 default = nil)
  if valid_594241 != nil:
    section.add "callback", valid_594241
  var valid_594242 = query.getOrDefault("access_token")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "access_token", valid_594242
  var valid_594243 = query.getOrDefault("uploadType")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "uploadType", valid_594243
  var valid_594244 = query.getOrDefault("key")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = nil)
  if valid_594244 != nil:
    section.add "key", valid_594244
  var valid_594245 = query.getOrDefault("$.xgafv")
  valid_594245 = validateParameter(valid_594245, JString, required = false,
                                 default = newJString("1"))
  if valid_594245 != nil:
    section.add "$.xgafv", valid_594245
  var valid_594246 = query.getOrDefault("pageSize")
  valid_594246 = validateParameter(valid_594246, JInt, required = false, default = nil)
  if valid_594246 != nil:
    section.add "pageSize", valid_594246
  var valid_594247 = query.getOrDefault("prettyPrint")
  valid_594247 = validateParameter(valid_594247, JBool, required = false,
                                 default = newJBool(true))
  if valid_594247 != nil:
    section.add "prettyPrint", valid_594247
  var valid_594248 = query.getOrDefault("filter")
  valid_594248 = validateParameter(valid_594248, JString, required = false,
                                 default = nil)
  if valid_594248 != nil:
    section.add "filter", valid_594248
  var valid_594249 = query.getOrDefault("bearer_token")
  valid_594249 = validateParameter(valid_594249, JString, required = false,
                                 default = nil)
  if valid_594249 != nil:
    section.add "bearer_token", valid_594249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594250: Call_DlpProjectsDlpJobsList_594229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists DlpJobs that match the specified filter in the request.
  ## 
  let valid = call_594250.validator(path, query, header, formData, body)
  let scheme = call_594250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594250.url(scheme.get, call_594250.host, call_594250.base,
                         call_594250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594250, url, valid)

proc call*(call_594251: Call_DlpProjectsDlpJobsList_594229; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          `type`: string = "DLP_JOB_TYPE_UNSPECIFIED"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""; bearerToken: string = ""): Recallable =
  ## dlpProjectsDlpJobsList
  ## Lists DlpJobs that match the specified filter in the request.
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
  ##   pp: bool
  ##     : Pretty-print response.
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
  ## * Supported fields for risk analysis jobs:
  ##     - `state` - RUNNING|CANCELED|FINISHED|FAILED
  ## * The operator must be `=` or `!=`.
  ## 
  ## Examples:
  ## 
  ## * inspected_storage = cloud_storage AND state = done
  ## * inspected_storage = cloud_storage OR inspected_storage = bigquery
  ## * inspected_storage = cloud_storage AND (state = done OR state = canceled)
  ## 
  ## The length of this field should be no more than 500 characters.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_594252 = newJObject()
  var query_594253 = newJObject()
  add(query_594253, "upload_protocol", newJString(uploadProtocol))
  add(query_594253, "fields", newJString(fields))
  add(query_594253, "pageToken", newJString(pageToken))
  add(query_594253, "quotaUser", newJString(quotaUser))
  add(query_594253, "alt", newJString(alt))
  add(query_594253, "pp", newJBool(pp))
  add(query_594253, "type", newJString(`type`))
  add(query_594253, "oauth_token", newJString(oauthToken))
  add(query_594253, "callback", newJString(callback))
  add(query_594253, "access_token", newJString(accessToken))
  add(query_594253, "uploadType", newJString(uploadType))
  add(path_594252, "parent", newJString(parent))
  add(query_594253, "key", newJString(key))
  add(query_594253, "$.xgafv", newJString(Xgafv))
  add(query_594253, "pageSize", newJInt(pageSize))
  add(query_594253, "prettyPrint", newJBool(prettyPrint))
  add(query_594253, "filter", newJString(filter))
  add(query_594253, "bearer_token", newJString(bearerToken))
  result = call_594251.call(path_594252, query_594253, nil, nil, nil)

var dlpProjectsDlpJobsList* = Call_DlpProjectsDlpJobsList_594229(
    name: "dlpProjectsDlpJobsList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/dlpJobs",
    validator: validate_DlpProjectsDlpJobsList_594230, base: "/",
    url: url_DlpProjectsDlpJobsList_594231, schemes: {Scheme.Https})
type
  Call_DlpProjectsImageRedact_594254 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsImageRedact_594256(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/image:redact")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsImageRedact_594255(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## [How-to guide](/dlp/docs/redacting-sensitive-data-images)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594257 = path.getOrDefault("parent")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "parent", valid_594257
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_594258 = query.getOrDefault("upload_protocol")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = nil)
  if valid_594258 != nil:
    section.add "upload_protocol", valid_594258
  var valid_594259 = query.getOrDefault("fields")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "fields", valid_594259
  var valid_594260 = query.getOrDefault("quotaUser")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "quotaUser", valid_594260
  var valid_594261 = query.getOrDefault("alt")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = newJString("json"))
  if valid_594261 != nil:
    section.add "alt", valid_594261
  var valid_594262 = query.getOrDefault("pp")
  valid_594262 = validateParameter(valid_594262, JBool, required = false,
                                 default = newJBool(true))
  if valid_594262 != nil:
    section.add "pp", valid_594262
  var valid_594263 = query.getOrDefault("oauth_token")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = nil)
  if valid_594263 != nil:
    section.add "oauth_token", valid_594263
  var valid_594264 = query.getOrDefault("callback")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = nil)
  if valid_594264 != nil:
    section.add "callback", valid_594264
  var valid_594265 = query.getOrDefault("access_token")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = nil)
  if valid_594265 != nil:
    section.add "access_token", valid_594265
  var valid_594266 = query.getOrDefault("uploadType")
  valid_594266 = validateParameter(valid_594266, JString, required = false,
                                 default = nil)
  if valid_594266 != nil:
    section.add "uploadType", valid_594266
  var valid_594267 = query.getOrDefault("key")
  valid_594267 = validateParameter(valid_594267, JString, required = false,
                                 default = nil)
  if valid_594267 != nil:
    section.add "key", valid_594267
  var valid_594268 = query.getOrDefault("$.xgafv")
  valid_594268 = validateParameter(valid_594268, JString, required = false,
                                 default = newJString("1"))
  if valid_594268 != nil:
    section.add "$.xgafv", valid_594268
  var valid_594269 = query.getOrDefault("prettyPrint")
  valid_594269 = validateParameter(valid_594269, JBool, required = false,
                                 default = newJBool(true))
  if valid_594269 != nil:
    section.add "prettyPrint", valid_594269
  var valid_594270 = query.getOrDefault("bearer_token")
  valid_594270 = validateParameter(valid_594270, JString, required = false,
                                 default = nil)
  if valid_594270 != nil:
    section.add "bearer_token", valid_594270
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

proc call*(call_594272: Call_DlpProjectsImageRedact_594254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## [How-to guide](/dlp/docs/redacting-sensitive-data-images)
  ## 
  let valid = call_594272.validator(path, query, header, formData, body)
  let scheme = call_594272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594272.url(scheme.get, call_594272.host, call_594272.base,
                         call_594272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594272, url, valid)

proc call*(call_594273: Call_DlpProjectsImageRedact_594254; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsImageRedact
  ## Redacts potentially sensitive info from an image.
  ## This method has limits on input size, processing time, and output size.
  ## [How-to guide](/dlp/docs/redacting-sensitive-data-images)
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_594274 = newJObject()
  var query_594275 = newJObject()
  var body_594276 = newJObject()
  add(query_594275, "upload_protocol", newJString(uploadProtocol))
  add(query_594275, "fields", newJString(fields))
  add(query_594275, "quotaUser", newJString(quotaUser))
  add(query_594275, "alt", newJString(alt))
  add(query_594275, "pp", newJBool(pp))
  add(query_594275, "oauth_token", newJString(oauthToken))
  add(query_594275, "callback", newJString(callback))
  add(query_594275, "access_token", newJString(accessToken))
  add(query_594275, "uploadType", newJString(uploadType))
  add(path_594274, "parent", newJString(parent))
  add(query_594275, "key", newJString(key))
  add(query_594275, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594276 = body
  add(query_594275, "prettyPrint", newJBool(prettyPrint))
  add(query_594275, "bearer_token", newJString(bearerToken))
  result = call_594273.call(path_594274, query_594275, nil, nil, body_594276)

var dlpProjectsImageRedact* = Call_DlpProjectsImageRedact_594254(
    name: "dlpProjectsImageRedact", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/image:redact",
    validator: validate_DlpProjectsImageRedact_594255, base: "/",
    url: url_DlpProjectsImageRedact_594256, schemes: {Scheme.Https})
type
  Call_DlpProjectsInspectTemplatesCreate_594300 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsInspectTemplatesCreate_594302(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/inspectTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsInspectTemplatesCreate_594301(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an inspect template for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594303 = path.getOrDefault("parent")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "parent", valid_594303
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_594304 = query.getOrDefault("upload_protocol")
  valid_594304 = validateParameter(valid_594304, JString, required = false,
                                 default = nil)
  if valid_594304 != nil:
    section.add "upload_protocol", valid_594304
  var valid_594305 = query.getOrDefault("fields")
  valid_594305 = validateParameter(valid_594305, JString, required = false,
                                 default = nil)
  if valid_594305 != nil:
    section.add "fields", valid_594305
  var valid_594306 = query.getOrDefault("quotaUser")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = nil)
  if valid_594306 != nil:
    section.add "quotaUser", valid_594306
  var valid_594307 = query.getOrDefault("alt")
  valid_594307 = validateParameter(valid_594307, JString, required = false,
                                 default = newJString("json"))
  if valid_594307 != nil:
    section.add "alt", valid_594307
  var valid_594308 = query.getOrDefault("pp")
  valid_594308 = validateParameter(valid_594308, JBool, required = false,
                                 default = newJBool(true))
  if valid_594308 != nil:
    section.add "pp", valid_594308
  var valid_594309 = query.getOrDefault("oauth_token")
  valid_594309 = validateParameter(valid_594309, JString, required = false,
                                 default = nil)
  if valid_594309 != nil:
    section.add "oauth_token", valid_594309
  var valid_594310 = query.getOrDefault("callback")
  valid_594310 = validateParameter(valid_594310, JString, required = false,
                                 default = nil)
  if valid_594310 != nil:
    section.add "callback", valid_594310
  var valid_594311 = query.getOrDefault("access_token")
  valid_594311 = validateParameter(valid_594311, JString, required = false,
                                 default = nil)
  if valid_594311 != nil:
    section.add "access_token", valid_594311
  var valid_594312 = query.getOrDefault("uploadType")
  valid_594312 = validateParameter(valid_594312, JString, required = false,
                                 default = nil)
  if valid_594312 != nil:
    section.add "uploadType", valid_594312
  var valid_594313 = query.getOrDefault("key")
  valid_594313 = validateParameter(valid_594313, JString, required = false,
                                 default = nil)
  if valid_594313 != nil:
    section.add "key", valid_594313
  var valid_594314 = query.getOrDefault("$.xgafv")
  valid_594314 = validateParameter(valid_594314, JString, required = false,
                                 default = newJString("1"))
  if valid_594314 != nil:
    section.add "$.xgafv", valid_594314
  var valid_594315 = query.getOrDefault("prettyPrint")
  valid_594315 = validateParameter(valid_594315, JBool, required = false,
                                 default = newJBool(true))
  if valid_594315 != nil:
    section.add "prettyPrint", valid_594315
  var valid_594316 = query.getOrDefault("bearer_token")
  valid_594316 = validateParameter(valid_594316, JString, required = false,
                                 default = nil)
  if valid_594316 != nil:
    section.add "bearer_token", valid_594316
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

proc call*(call_594318: Call_DlpProjectsInspectTemplatesCreate_594300;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an inspect template for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ## 
  let valid = call_594318.validator(path, query, header, formData, body)
  let scheme = call_594318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594318.url(scheme.get, call_594318.host, call_594318.base,
                         call_594318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594318, url, valid)

proc call*(call_594319: Call_DlpProjectsInspectTemplatesCreate_594300;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsInspectTemplatesCreate
  ## Creates an inspect template for re-using frequently used configuration
  ## for inspecting content, images, and storage.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_594320 = newJObject()
  var query_594321 = newJObject()
  var body_594322 = newJObject()
  add(query_594321, "upload_protocol", newJString(uploadProtocol))
  add(query_594321, "fields", newJString(fields))
  add(query_594321, "quotaUser", newJString(quotaUser))
  add(query_594321, "alt", newJString(alt))
  add(query_594321, "pp", newJBool(pp))
  add(query_594321, "oauth_token", newJString(oauthToken))
  add(query_594321, "callback", newJString(callback))
  add(query_594321, "access_token", newJString(accessToken))
  add(query_594321, "uploadType", newJString(uploadType))
  add(path_594320, "parent", newJString(parent))
  add(query_594321, "key", newJString(key))
  add(query_594321, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594322 = body
  add(query_594321, "prettyPrint", newJBool(prettyPrint))
  add(query_594321, "bearer_token", newJString(bearerToken))
  result = call_594319.call(path_594320, query_594321, nil, nil, body_594322)

var dlpProjectsInspectTemplatesCreate* = Call_DlpProjectsInspectTemplatesCreate_594300(
    name: "dlpProjectsInspectTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/inspectTemplates",
    validator: validate_DlpProjectsInspectTemplatesCreate_594301, base: "/",
    url: url_DlpProjectsInspectTemplatesCreate_594302, schemes: {Scheme.Https})
type
  Call_DlpProjectsInspectTemplatesList_594277 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsInspectTemplatesList_594279(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/inspectTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsInspectTemplatesList_594278(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists inspect templates.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id or
  ## organizations/my-org-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594280 = path.getOrDefault("parent")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "parent", valid_594280
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_594281 = query.getOrDefault("upload_protocol")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = nil)
  if valid_594281 != nil:
    section.add "upload_protocol", valid_594281
  var valid_594282 = query.getOrDefault("fields")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = nil)
  if valid_594282 != nil:
    section.add "fields", valid_594282
  var valid_594283 = query.getOrDefault("pageToken")
  valid_594283 = validateParameter(valid_594283, JString, required = false,
                                 default = nil)
  if valid_594283 != nil:
    section.add "pageToken", valid_594283
  var valid_594284 = query.getOrDefault("quotaUser")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = nil)
  if valid_594284 != nil:
    section.add "quotaUser", valid_594284
  var valid_594285 = query.getOrDefault("alt")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = newJString("json"))
  if valid_594285 != nil:
    section.add "alt", valid_594285
  var valid_594286 = query.getOrDefault("pp")
  valid_594286 = validateParameter(valid_594286, JBool, required = false,
                                 default = newJBool(true))
  if valid_594286 != nil:
    section.add "pp", valid_594286
  var valid_594287 = query.getOrDefault("oauth_token")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = nil)
  if valid_594287 != nil:
    section.add "oauth_token", valid_594287
  var valid_594288 = query.getOrDefault("callback")
  valid_594288 = validateParameter(valid_594288, JString, required = false,
                                 default = nil)
  if valid_594288 != nil:
    section.add "callback", valid_594288
  var valid_594289 = query.getOrDefault("access_token")
  valid_594289 = validateParameter(valid_594289, JString, required = false,
                                 default = nil)
  if valid_594289 != nil:
    section.add "access_token", valid_594289
  var valid_594290 = query.getOrDefault("uploadType")
  valid_594290 = validateParameter(valid_594290, JString, required = false,
                                 default = nil)
  if valid_594290 != nil:
    section.add "uploadType", valid_594290
  var valid_594291 = query.getOrDefault("key")
  valid_594291 = validateParameter(valid_594291, JString, required = false,
                                 default = nil)
  if valid_594291 != nil:
    section.add "key", valid_594291
  var valid_594292 = query.getOrDefault("$.xgafv")
  valid_594292 = validateParameter(valid_594292, JString, required = false,
                                 default = newJString("1"))
  if valid_594292 != nil:
    section.add "$.xgafv", valid_594292
  var valid_594293 = query.getOrDefault("pageSize")
  valid_594293 = validateParameter(valid_594293, JInt, required = false, default = nil)
  if valid_594293 != nil:
    section.add "pageSize", valid_594293
  var valid_594294 = query.getOrDefault("prettyPrint")
  valid_594294 = validateParameter(valid_594294, JBool, required = false,
                                 default = newJBool(true))
  if valid_594294 != nil:
    section.add "prettyPrint", valid_594294
  var valid_594295 = query.getOrDefault("bearer_token")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = nil)
  if valid_594295 != nil:
    section.add "bearer_token", valid_594295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594296: Call_DlpProjectsInspectTemplatesList_594277;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists inspect templates.
  ## 
  let valid = call_594296.validator(path, query, header, formData, body)
  let scheme = call_594296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594296.url(scheme.get, call_594296.host, call_594296.base,
                         call_594296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594296, url, valid)

proc call*(call_594297: Call_DlpProjectsInspectTemplatesList_594277;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dlpProjectsInspectTemplatesList
  ## Lists inspect templates.
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
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by server. If zero server returns
  ## a page of max size 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_594298 = newJObject()
  var query_594299 = newJObject()
  add(query_594299, "upload_protocol", newJString(uploadProtocol))
  add(query_594299, "fields", newJString(fields))
  add(query_594299, "pageToken", newJString(pageToken))
  add(query_594299, "quotaUser", newJString(quotaUser))
  add(query_594299, "alt", newJString(alt))
  add(query_594299, "pp", newJBool(pp))
  add(query_594299, "oauth_token", newJString(oauthToken))
  add(query_594299, "callback", newJString(callback))
  add(query_594299, "access_token", newJString(accessToken))
  add(query_594299, "uploadType", newJString(uploadType))
  add(path_594298, "parent", newJString(parent))
  add(query_594299, "key", newJString(key))
  add(query_594299, "$.xgafv", newJString(Xgafv))
  add(query_594299, "pageSize", newJInt(pageSize))
  add(query_594299, "prettyPrint", newJBool(prettyPrint))
  add(query_594299, "bearer_token", newJString(bearerToken))
  result = call_594297.call(path_594298, query_594299, nil, nil, nil)

var dlpProjectsInspectTemplatesList* = Call_DlpProjectsInspectTemplatesList_594277(
    name: "dlpProjectsInspectTemplatesList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/inspectTemplates",
    validator: validate_DlpProjectsInspectTemplatesList_594278, base: "/",
    url: url_DlpProjectsInspectTemplatesList_594279, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersCreate_594347 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsJobTriggersCreate_594349(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobTriggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersCreate_594348(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a job to run DLP actions such as scanning storage for sensitive
  ## information on a set schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594350 = path.getOrDefault("parent")
  valid_594350 = validateParameter(valid_594350, JString, required = true,
                                 default = nil)
  if valid_594350 != nil:
    section.add "parent", valid_594350
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_594351 = query.getOrDefault("upload_protocol")
  valid_594351 = validateParameter(valid_594351, JString, required = false,
                                 default = nil)
  if valid_594351 != nil:
    section.add "upload_protocol", valid_594351
  var valid_594352 = query.getOrDefault("fields")
  valid_594352 = validateParameter(valid_594352, JString, required = false,
                                 default = nil)
  if valid_594352 != nil:
    section.add "fields", valid_594352
  var valid_594353 = query.getOrDefault("quotaUser")
  valid_594353 = validateParameter(valid_594353, JString, required = false,
                                 default = nil)
  if valid_594353 != nil:
    section.add "quotaUser", valid_594353
  var valid_594354 = query.getOrDefault("alt")
  valid_594354 = validateParameter(valid_594354, JString, required = false,
                                 default = newJString("json"))
  if valid_594354 != nil:
    section.add "alt", valid_594354
  var valid_594355 = query.getOrDefault("pp")
  valid_594355 = validateParameter(valid_594355, JBool, required = false,
                                 default = newJBool(true))
  if valid_594355 != nil:
    section.add "pp", valid_594355
  var valid_594356 = query.getOrDefault("oauth_token")
  valid_594356 = validateParameter(valid_594356, JString, required = false,
                                 default = nil)
  if valid_594356 != nil:
    section.add "oauth_token", valid_594356
  var valid_594357 = query.getOrDefault("callback")
  valid_594357 = validateParameter(valid_594357, JString, required = false,
                                 default = nil)
  if valid_594357 != nil:
    section.add "callback", valid_594357
  var valid_594358 = query.getOrDefault("access_token")
  valid_594358 = validateParameter(valid_594358, JString, required = false,
                                 default = nil)
  if valid_594358 != nil:
    section.add "access_token", valid_594358
  var valid_594359 = query.getOrDefault("uploadType")
  valid_594359 = validateParameter(valid_594359, JString, required = false,
                                 default = nil)
  if valid_594359 != nil:
    section.add "uploadType", valid_594359
  var valid_594360 = query.getOrDefault("key")
  valid_594360 = validateParameter(valid_594360, JString, required = false,
                                 default = nil)
  if valid_594360 != nil:
    section.add "key", valid_594360
  var valid_594361 = query.getOrDefault("$.xgafv")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = newJString("1"))
  if valid_594361 != nil:
    section.add "$.xgafv", valid_594361
  var valid_594362 = query.getOrDefault("prettyPrint")
  valid_594362 = validateParameter(valid_594362, JBool, required = false,
                                 default = newJBool(true))
  if valid_594362 != nil:
    section.add "prettyPrint", valid_594362
  var valid_594363 = query.getOrDefault("bearer_token")
  valid_594363 = validateParameter(valid_594363, JString, required = false,
                                 default = nil)
  if valid_594363 != nil:
    section.add "bearer_token", valid_594363
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

proc call*(call_594365: Call_DlpProjectsJobTriggersCreate_594347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a job to run DLP actions such as scanning storage for sensitive
  ## information on a set schedule.
  ## 
  let valid = call_594365.validator(path, query, header, formData, body)
  let scheme = call_594365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594365.url(scheme.get, call_594365.host, call_594365.base,
                         call_594365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594365, url, valid)

proc call*(call_594366: Call_DlpProjectsJobTriggersCreate_594347; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dlpProjectsJobTriggersCreate
  ## Creates a job to run DLP actions such as scanning storage for sensitive
  ## information on a set schedule.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_594367 = newJObject()
  var query_594368 = newJObject()
  var body_594369 = newJObject()
  add(query_594368, "upload_protocol", newJString(uploadProtocol))
  add(query_594368, "fields", newJString(fields))
  add(query_594368, "quotaUser", newJString(quotaUser))
  add(query_594368, "alt", newJString(alt))
  add(query_594368, "pp", newJBool(pp))
  add(query_594368, "oauth_token", newJString(oauthToken))
  add(query_594368, "callback", newJString(callback))
  add(query_594368, "access_token", newJString(accessToken))
  add(query_594368, "uploadType", newJString(uploadType))
  add(path_594367, "parent", newJString(parent))
  add(query_594368, "key", newJString(key))
  add(query_594368, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594369 = body
  add(query_594368, "prettyPrint", newJBool(prettyPrint))
  add(query_594368, "bearer_token", newJString(bearerToken))
  result = call_594366.call(path_594367, query_594368, nil, nil, body_594369)

var dlpProjectsJobTriggersCreate* = Call_DlpProjectsJobTriggersCreate_594347(
    name: "dlpProjectsJobTriggersCreate", meth: HttpMethod.HttpPost,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/jobTriggers",
    validator: validate_DlpProjectsJobTriggersCreate_594348, base: "/",
    url: url_DlpProjectsJobTriggersCreate_594349, schemes: {Scheme.Https})
type
  Call_DlpProjectsJobTriggersList_594323 = ref object of OpenApiRestCall_593421
proc url_DlpProjectsJobTriggersList_594325(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobTriggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DlpProjectsJobTriggersList_594324(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists job triggers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name, for example projects/my-project-id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594326 = path.getOrDefault("parent")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "parent", valid_594326
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to ListJobTriggers. `order_by` and `filter` should not change for
  ## subsequent calls, but can be omitted if token is specified.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ## followed by 'asc/desc' postfix, i.e.
  ## `"create_time asc,name desc,schedule_mode asc"`. This list is
  ## case-insensitive.
  ## 
  ## Example: `"name asc,schedule_mode desc, status desc"`
  ## 
  ## Supported filters keys and values are:
  ## 
  ## - `create_time`: corresponds to time the triggeredJob was created.
  ## - `update_time`: corresponds to time the triggeredJob was last updated.
  ## - `name`: corresponds to JobTrigger's display name.
  ## - `status`: corresponds to the triggeredJob status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional size of the page, can be limited by a server.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_594327 = query.getOrDefault("upload_protocol")
  valid_594327 = validateParameter(valid_594327, JString, required = false,
                                 default = nil)
  if valid_594327 != nil:
    section.add "upload_protocol", valid_594327
  var valid_594328 = query.getOrDefault("fields")
  valid_594328 = validateParameter(valid_594328, JString, required = false,
                                 default = nil)
  if valid_594328 != nil:
    section.add "fields", valid_594328
  var valid_594329 = query.getOrDefault("pageToken")
  valid_594329 = validateParameter(valid_594329, JString, required = false,
                                 default = nil)
  if valid_594329 != nil:
    section.add "pageToken", valid_594329
  var valid_594330 = query.getOrDefault("quotaUser")
  valid_594330 = validateParameter(valid_594330, JString, required = false,
                                 default = nil)
  if valid_594330 != nil:
    section.add "quotaUser", valid_594330
  var valid_594331 = query.getOrDefault("alt")
  valid_594331 = validateParameter(valid_594331, JString, required = false,
                                 default = newJString("json"))
  if valid_594331 != nil:
    section.add "alt", valid_594331
  var valid_594332 = query.getOrDefault("pp")
  valid_594332 = validateParameter(valid_594332, JBool, required = false,
                                 default = newJBool(true))
  if valid_594332 != nil:
    section.add "pp", valid_594332
  var valid_594333 = query.getOrDefault("oauth_token")
  valid_594333 = validateParameter(valid_594333, JString, required = false,
                                 default = nil)
  if valid_594333 != nil:
    section.add "oauth_token", valid_594333
  var valid_594334 = query.getOrDefault("callback")
  valid_594334 = validateParameter(valid_594334, JString, required = false,
                                 default = nil)
  if valid_594334 != nil:
    section.add "callback", valid_594334
  var valid_594335 = query.getOrDefault("access_token")
  valid_594335 = validateParameter(valid_594335, JString, required = false,
                                 default = nil)
  if valid_594335 != nil:
    section.add "access_token", valid_594335
  var valid_594336 = query.getOrDefault("uploadType")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = nil)
  if valid_594336 != nil:
    section.add "uploadType", valid_594336
  var valid_594337 = query.getOrDefault("orderBy")
  valid_594337 = validateParameter(valid_594337, JString, required = false,
                                 default = nil)
  if valid_594337 != nil:
    section.add "orderBy", valid_594337
  var valid_594338 = query.getOrDefault("key")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = nil)
  if valid_594338 != nil:
    section.add "key", valid_594338
  var valid_594339 = query.getOrDefault("$.xgafv")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = newJString("1"))
  if valid_594339 != nil:
    section.add "$.xgafv", valid_594339
  var valid_594340 = query.getOrDefault("pageSize")
  valid_594340 = validateParameter(valid_594340, JInt, required = false, default = nil)
  if valid_594340 != nil:
    section.add "pageSize", valid_594340
  var valid_594341 = query.getOrDefault("prettyPrint")
  valid_594341 = validateParameter(valid_594341, JBool, required = false,
                                 default = newJBool(true))
  if valid_594341 != nil:
    section.add "prettyPrint", valid_594341
  var valid_594342 = query.getOrDefault("bearer_token")
  valid_594342 = validateParameter(valid_594342, JString, required = false,
                                 default = nil)
  if valid_594342 != nil:
    section.add "bearer_token", valid_594342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594343: Call_DlpProjectsJobTriggersList_594323; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists job triggers.
  ## 
  let valid = call_594343.validator(path, query, header, formData, body)
  let scheme = call_594343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594343.url(scheme.get, call_594343.host, call_594343.base,
                         call_594343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594343, url, valid)

proc call*(call_594344: Call_DlpProjectsJobTriggersList_594323; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dlpProjectsJobTriggersList
  ## Lists job triggers.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional page token to continue retrieval. Comes from previous call
  ## to ListJobTriggers. `order_by` and `filter` should not change for
  ## subsequent calls, but can be omitted if token is specified.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##          : Optional comma separated list of triggeredJob fields to order by,
  ## followed by 'asc/desc' postfix, i.e.
  ## `"create_time asc,name desc,schedule_mode asc"`. This list is
  ## case-insensitive.
  ## 
  ## Example: `"name asc,schedule_mode desc, status desc"`
  ## 
  ## Supported filters keys and values are:
  ## 
  ## - `create_time`: corresponds to time the triggeredJob was created.
  ## - `update_time`: corresponds to time the triggeredJob was last updated.
  ## - `name`: corresponds to JobTrigger's display name.
  ## - `status`: corresponds to the triggeredJob status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional size of the page, can be limited by a server.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_594345 = newJObject()
  var query_594346 = newJObject()
  add(query_594346, "upload_protocol", newJString(uploadProtocol))
  add(query_594346, "fields", newJString(fields))
  add(query_594346, "pageToken", newJString(pageToken))
  add(query_594346, "quotaUser", newJString(quotaUser))
  add(query_594346, "alt", newJString(alt))
  add(query_594346, "pp", newJBool(pp))
  add(query_594346, "oauth_token", newJString(oauthToken))
  add(query_594346, "callback", newJString(callback))
  add(query_594346, "access_token", newJString(accessToken))
  add(query_594346, "uploadType", newJString(uploadType))
  add(path_594345, "parent", newJString(parent))
  add(query_594346, "orderBy", newJString(orderBy))
  add(query_594346, "key", newJString(key))
  add(query_594346, "$.xgafv", newJString(Xgafv))
  add(query_594346, "pageSize", newJInt(pageSize))
  add(query_594346, "prettyPrint", newJBool(prettyPrint))
  add(query_594346, "bearer_token", newJString(bearerToken))
  result = call_594344.call(path_594345, query_594346, nil, nil, nil)

var dlpProjectsJobTriggersList* = Call_DlpProjectsJobTriggersList_594323(
    name: "dlpProjectsJobTriggersList", meth: HttpMethod.HttpGet,
    host: "dlp.googleapis.com", route: "/v2beta2/{parent}/jobTriggers",
    validator: validate_DlpProjectsJobTriggersList_594324, base: "/",
    url: url_DlpProjectsJobTriggersList_594325, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
