
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Storage Transfer
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Transfers data from external data sources to a Google Cloud Storage bucket or between Google Cloud Storage buckets.
## 
## https://cloud.google.com/storage-transfer/docs
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  gcpServiceName = "storagetransfer"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StoragetransferGoogleServiceAccountsGet_593677 = ref object of OpenApiRestCall_593408
proc url_StoragetransferGoogleServiceAccountsGet_593679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/googleServiceAccounts/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StoragetransferGoogleServiceAccountsGet_593678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the Google service account that is used by Storage Transfer
  ## Service to access buckets in the project where transfers
  ## run or in other projects. Each Google service account is associated
  ## with one Google Cloud Platform Console project. Users
  ## should add this service account to the Google Cloud Storage bucket
  ## ACLs to grant access to Storage Transfer Service. This service
  ## account is created and owned by Storage Transfer Service and can
  ## only be used by Storage Transfer Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. The ID of the Google Cloud Platform Console project that the
  ## Google service account is associated with.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_593805 = path.getOrDefault("projectId")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "projectId", valid_593805
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
  var valid_593806 = query.getOrDefault("upload_protocol")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "upload_protocol", valid_593806
  var valid_593807 = query.getOrDefault("fields")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "fields", valid_593807
  var valid_593808 = query.getOrDefault("quotaUser")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "quotaUser", valid_593808
  var valid_593822 = query.getOrDefault("alt")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = newJString("json"))
  if valid_593822 != nil:
    section.add "alt", valid_593822
  var valid_593823 = query.getOrDefault("oauth_token")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "oauth_token", valid_593823
  var valid_593824 = query.getOrDefault("callback")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "callback", valid_593824
  var valid_593825 = query.getOrDefault("access_token")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "access_token", valid_593825
  var valid_593826 = query.getOrDefault("uploadType")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "uploadType", valid_593826
  var valid_593827 = query.getOrDefault("key")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "key", valid_593827
  var valid_593828 = query.getOrDefault("$.xgafv")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = newJString("1"))
  if valid_593828 != nil:
    section.add "$.xgafv", valid_593828
  var valid_593829 = query.getOrDefault("prettyPrint")
  valid_593829 = validateParameter(valid_593829, JBool, required = false,
                                 default = newJBool(true))
  if valid_593829 != nil:
    section.add "prettyPrint", valid_593829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593852: Call_StoragetransferGoogleServiceAccountsGet_593677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the Google service account that is used by Storage Transfer
  ## Service to access buckets in the project where transfers
  ## run or in other projects. Each Google service account is associated
  ## with one Google Cloud Platform Console project. Users
  ## should add this service account to the Google Cloud Storage bucket
  ## ACLs to grant access to Storage Transfer Service. This service
  ## account is created and owned by Storage Transfer Service and can
  ## only be used by Storage Transfer Service.
  ## 
  let valid = call_593852.validator(path, query, header, formData, body)
  let scheme = call_593852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593852.url(scheme.get, call_593852.host, call_593852.base,
                         call_593852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593852, url, valid)

proc call*(call_593923: Call_StoragetransferGoogleServiceAccountsGet_593677;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## storagetransferGoogleServiceAccountsGet
  ## Returns the Google service account that is used by Storage Transfer
  ## Service to access buckets in the project where transfers
  ## run or in other projects. Each Google service account is associated
  ## with one Google Cloud Platform Console project. Users
  ## should add this service account to the Google Cloud Storage bucket
  ## ACLs to grant access to Storage Transfer Service. This service
  ## account is created and owned by Storage Transfer Service and can
  ## only be used by Storage Transfer Service.
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
  ##   projectId: string (required)
  ##            : Required. The ID of the Google Cloud Platform Console project that the
  ## Google service account is associated with.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_593924 = newJObject()
  var query_593926 = newJObject()
  add(query_593926, "upload_protocol", newJString(uploadProtocol))
  add(query_593926, "fields", newJString(fields))
  add(query_593926, "quotaUser", newJString(quotaUser))
  add(query_593926, "alt", newJString(alt))
  add(query_593926, "oauth_token", newJString(oauthToken))
  add(query_593926, "callback", newJString(callback))
  add(query_593926, "access_token", newJString(accessToken))
  add(query_593926, "uploadType", newJString(uploadType))
  add(query_593926, "key", newJString(key))
  add(path_593924, "projectId", newJString(projectId))
  add(query_593926, "$.xgafv", newJString(Xgafv))
  add(query_593926, "prettyPrint", newJBool(prettyPrint))
  result = call_593923.call(path_593924, query_593926, nil, nil, nil)

var storagetransferGoogleServiceAccountsGet* = Call_StoragetransferGoogleServiceAccountsGet_593677(
    name: "storagetransferGoogleServiceAccountsGet", meth: HttpMethod.HttpGet,
    host: "storagetransfer.googleapis.com",
    route: "/v1/googleServiceAccounts/{projectId}",
    validator: validate_StoragetransferGoogleServiceAccountsGet_593678, base: "/",
    url: url_StoragetransferGoogleServiceAccountsGet_593679,
    schemes: {Scheme.Https})
type
  Call_StoragetransferTransferJobsCreate_593985 = ref object of OpenApiRestCall_593408
proc url_StoragetransferTransferJobsCreate_593987(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StoragetransferTransferJobsCreate_593986(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a transfer job that runs periodically.
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
  var valid_593988 = query.getOrDefault("upload_protocol")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "upload_protocol", valid_593988
  var valid_593989 = query.getOrDefault("fields")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "fields", valid_593989
  var valid_593990 = query.getOrDefault("quotaUser")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "quotaUser", valid_593990
  var valid_593991 = query.getOrDefault("alt")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("json"))
  if valid_593991 != nil:
    section.add "alt", valid_593991
  var valid_593992 = query.getOrDefault("oauth_token")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "oauth_token", valid_593992
  var valid_593993 = query.getOrDefault("callback")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "callback", valid_593993
  var valid_593994 = query.getOrDefault("access_token")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "access_token", valid_593994
  var valid_593995 = query.getOrDefault("uploadType")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "uploadType", valid_593995
  var valid_593996 = query.getOrDefault("key")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "key", valid_593996
  var valid_593997 = query.getOrDefault("$.xgafv")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = newJString("1"))
  if valid_593997 != nil:
    section.add "$.xgafv", valid_593997
  var valid_593998 = query.getOrDefault("prettyPrint")
  valid_593998 = validateParameter(valid_593998, JBool, required = false,
                                 default = newJBool(true))
  if valid_593998 != nil:
    section.add "prettyPrint", valid_593998
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

proc call*(call_594000: Call_StoragetransferTransferJobsCreate_593985;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a transfer job that runs periodically.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_StoragetransferTransferJobsCreate_593985;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## storagetransferTransferJobsCreate
  ## Creates a transfer job that runs periodically.
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
  var query_594002 = newJObject()
  var body_594003 = newJObject()
  add(query_594002, "upload_protocol", newJString(uploadProtocol))
  add(query_594002, "fields", newJString(fields))
  add(query_594002, "quotaUser", newJString(quotaUser))
  add(query_594002, "alt", newJString(alt))
  add(query_594002, "oauth_token", newJString(oauthToken))
  add(query_594002, "callback", newJString(callback))
  add(query_594002, "access_token", newJString(accessToken))
  add(query_594002, "uploadType", newJString(uploadType))
  add(query_594002, "key", newJString(key))
  add(query_594002, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594003 = body
  add(query_594002, "prettyPrint", newJBool(prettyPrint))
  result = call_594001.call(nil, query_594002, nil, nil, body_594003)

var storagetransferTransferJobsCreate* = Call_StoragetransferTransferJobsCreate_593985(
    name: "storagetransferTransferJobsCreate", meth: HttpMethod.HttpPost,
    host: "storagetransfer.googleapis.com", route: "/v1/transferJobs",
    validator: validate_StoragetransferTransferJobsCreate_593986, base: "/",
    url: url_StoragetransferTransferJobsCreate_593987, schemes: {Scheme.Https})
type
  Call_StoragetransferTransferJobsList_593965 = ref object of OpenApiRestCall_593408
proc url_StoragetransferTransferJobsList_593967(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StoragetransferTransferJobsList_593966(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists transfer jobs.
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
  ##   pageToken: JString
  ##            : The list page token.
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
  ##   pageSize: JInt
  ##           : The list page size. The max allowed value is 256.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Required. A list of query parameters specified as JSON text in the form of:
  ## {"project_id":"my_project_id",
  ##  "job_names":["jobid1","jobid2",...],
  ##  "job_statuses":["status1","status2",...]}.
  ## Since `job_names` and `job_statuses` support multiple values, their values
  ## must be specified with array notation. `project_id` is required.
  ## `job_names` and `job_statuses` are optional.  The valid values for
  ## `job_statuses` are case-insensitive: `ENABLED`, `DISABLED`, and `DELETED`.
  section = newJObject()
  var valid_593968 = query.getOrDefault("upload_protocol")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "upload_protocol", valid_593968
  var valid_593969 = query.getOrDefault("fields")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "fields", valid_593969
  var valid_593970 = query.getOrDefault("pageToken")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "pageToken", valid_593970
  var valid_593971 = query.getOrDefault("quotaUser")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "quotaUser", valid_593971
  var valid_593972 = query.getOrDefault("alt")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = newJString("json"))
  if valid_593972 != nil:
    section.add "alt", valid_593972
  var valid_593973 = query.getOrDefault("oauth_token")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "oauth_token", valid_593973
  var valid_593974 = query.getOrDefault("callback")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "callback", valid_593974
  var valid_593975 = query.getOrDefault("access_token")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "access_token", valid_593975
  var valid_593976 = query.getOrDefault("uploadType")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "uploadType", valid_593976
  var valid_593977 = query.getOrDefault("key")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "key", valid_593977
  var valid_593978 = query.getOrDefault("$.xgafv")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = newJString("1"))
  if valid_593978 != nil:
    section.add "$.xgafv", valid_593978
  var valid_593979 = query.getOrDefault("pageSize")
  valid_593979 = validateParameter(valid_593979, JInt, required = false, default = nil)
  if valid_593979 != nil:
    section.add "pageSize", valid_593979
  var valid_593980 = query.getOrDefault("prettyPrint")
  valid_593980 = validateParameter(valid_593980, JBool, required = false,
                                 default = newJBool(true))
  if valid_593980 != nil:
    section.add "prettyPrint", valid_593980
  var valid_593981 = query.getOrDefault("filter")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "filter", valid_593981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593982: Call_StoragetransferTransferJobsList_593965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists transfer jobs.
  ## 
  let valid = call_593982.validator(path, query, header, formData, body)
  let scheme = call_593982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593982.url(scheme.get, call_593982.host, call_593982.base,
                         call_593982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593982, url, valid)

proc call*(call_593983: Call_StoragetransferTransferJobsList_593965;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## storagetransferTransferJobsList
  ## Lists transfer jobs.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The list page token.
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
  ##   pageSize: int
  ##           : The list page size. The max allowed value is 256.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Required. A list of query parameters specified as JSON text in the form of:
  ## {"project_id":"my_project_id",
  ##  "job_names":["jobid1","jobid2",...],
  ##  "job_statuses":["status1","status2",...]}.
  ## Since `job_names` and `job_statuses` support multiple values, their values
  ## must be specified with array notation. `project_id` is required.
  ## `job_names` and `job_statuses` are optional.  The valid values for
  ## `job_statuses` are case-insensitive: `ENABLED`, `DISABLED`, and `DELETED`.
  var query_593984 = newJObject()
  add(query_593984, "upload_protocol", newJString(uploadProtocol))
  add(query_593984, "fields", newJString(fields))
  add(query_593984, "pageToken", newJString(pageToken))
  add(query_593984, "quotaUser", newJString(quotaUser))
  add(query_593984, "alt", newJString(alt))
  add(query_593984, "oauth_token", newJString(oauthToken))
  add(query_593984, "callback", newJString(callback))
  add(query_593984, "access_token", newJString(accessToken))
  add(query_593984, "uploadType", newJString(uploadType))
  add(query_593984, "key", newJString(key))
  add(query_593984, "$.xgafv", newJString(Xgafv))
  add(query_593984, "pageSize", newJInt(pageSize))
  add(query_593984, "prettyPrint", newJBool(prettyPrint))
  add(query_593984, "filter", newJString(filter))
  result = call_593983.call(nil, query_593984, nil, nil, nil)

var storagetransferTransferJobsList* = Call_StoragetransferTransferJobsList_593965(
    name: "storagetransferTransferJobsList", meth: HttpMethod.HttpGet,
    host: "storagetransfer.googleapis.com", route: "/v1/transferJobs",
    validator: validate_StoragetransferTransferJobsList_593966, base: "/",
    url: url_StoragetransferTransferJobsList_593967, schemes: {Scheme.Https})
type
  Call_StoragetransferTransferJobsGet_594004 = ref object of OpenApiRestCall_593408
proc url_StoragetransferTransferJobsGet_594006(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StoragetransferTransferJobsGet_594005(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a transfer job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobName: JString (required)
  ##          : Required. The job to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobName` field"
  var valid_594007 = path.getOrDefault("jobName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "jobName", valid_594007
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
  ##   projectId: JString
  ##            : Required. The ID of the Google Cloud Platform Console project that owns the
  ## job.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594008 = query.getOrDefault("upload_protocol")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "upload_protocol", valid_594008
  var valid_594009 = query.getOrDefault("fields")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "fields", valid_594009
  var valid_594010 = query.getOrDefault("quotaUser")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "quotaUser", valid_594010
  var valid_594011 = query.getOrDefault("alt")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = newJString("json"))
  if valid_594011 != nil:
    section.add "alt", valid_594011
  var valid_594012 = query.getOrDefault("oauth_token")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "oauth_token", valid_594012
  var valid_594013 = query.getOrDefault("callback")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "callback", valid_594013
  var valid_594014 = query.getOrDefault("access_token")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "access_token", valid_594014
  var valid_594015 = query.getOrDefault("uploadType")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "uploadType", valid_594015
  var valid_594016 = query.getOrDefault("key")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "key", valid_594016
  var valid_594017 = query.getOrDefault("$.xgafv")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = newJString("1"))
  if valid_594017 != nil:
    section.add "$.xgafv", valid_594017
  var valid_594018 = query.getOrDefault("projectId")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "projectId", valid_594018
  var valid_594019 = query.getOrDefault("prettyPrint")
  valid_594019 = validateParameter(valid_594019, JBool, required = false,
                                 default = newJBool(true))
  if valid_594019 != nil:
    section.add "prettyPrint", valid_594019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594020: Call_StoragetransferTransferJobsGet_594004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a transfer job.
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_StoragetransferTransferJobsGet_594004;
          jobName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true): Recallable =
  ## storagetransferTransferJobsGet
  ## Gets a transfer job.
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
  ##   jobName: string (required)
  ##          : Required. The job to get.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : Required. The ID of the Google Cloud Platform Console project that owns the
  ## job.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594022 = newJObject()
  var query_594023 = newJObject()
  add(query_594023, "upload_protocol", newJString(uploadProtocol))
  add(query_594023, "fields", newJString(fields))
  add(query_594023, "quotaUser", newJString(quotaUser))
  add(query_594023, "alt", newJString(alt))
  add(query_594023, "oauth_token", newJString(oauthToken))
  add(query_594023, "callback", newJString(callback))
  add(query_594023, "access_token", newJString(accessToken))
  add(query_594023, "uploadType", newJString(uploadType))
  add(path_594022, "jobName", newJString(jobName))
  add(query_594023, "key", newJString(key))
  add(query_594023, "$.xgafv", newJString(Xgafv))
  add(query_594023, "projectId", newJString(projectId))
  add(query_594023, "prettyPrint", newJBool(prettyPrint))
  result = call_594021.call(path_594022, query_594023, nil, nil, nil)

var storagetransferTransferJobsGet* = Call_StoragetransferTransferJobsGet_594004(
    name: "storagetransferTransferJobsGet", meth: HttpMethod.HttpGet,
    host: "storagetransfer.googleapis.com", route: "/v1/{jobName}",
    validator: validate_StoragetransferTransferJobsGet_594005, base: "/",
    url: url_StoragetransferTransferJobsGet_594006, schemes: {Scheme.Https})
type
  Call_StoragetransferTransferJobsPatch_594024 = ref object of OpenApiRestCall_593408
proc url_StoragetransferTransferJobsPatch_594026(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StoragetransferTransferJobsPatch_594025(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a transfer job. Updating a job's transfer spec does not affect
  ## transfer operations that are running already. Updating the scheduling
  ## of a job is not allowed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobName: JString (required)
  ##          : Required. The name of job to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobName` field"
  var valid_594027 = path.getOrDefault("jobName")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "jobName", valid_594027
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
  var valid_594028 = query.getOrDefault("upload_protocol")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "upload_protocol", valid_594028
  var valid_594029 = query.getOrDefault("fields")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "fields", valid_594029
  var valid_594030 = query.getOrDefault("quotaUser")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "quotaUser", valid_594030
  var valid_594031 = query.getOrDefault("alt")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = newJString("json"))
  if valid_594031 != nil:
    section.add "alt", valid_594031
  var valid_594032 = query.getOrDefault("oauth_token")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "oauth_token", valid_594032
  var valid_594033 = query.getOrDefault("callback")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "callback", valid_594033
  var valid_594034 = query.getOrDefault("access_token")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "access_token", valid_594034
  var valid_594035 = query.getOrDefault("uploadType")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "uploadType", valid_594035
  var valid_594036 = query.getOrDefault("key")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "key", valid_594036
  var valid_594037 = query.getOrDefault("$.xgafv")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = newJString("1"))
  if valid_594037 != nil:
    section.add "$.xgafv", valid_594037
  var valid_594038 = query.getOrDefault("prettyPrint")
  valid_594038 = validateParameter(valid_594038, JBool, required = false,
                                 default = newJBool(true))
  if valid_594038 != nil:
    section.add "prettyPrint", valid_594038
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

proc call*(call_594040: Call_StoragetransferTransferJobsPatch_594024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a transfer job. Updating a job's transfer spec does not affect
  ## transfer operations that are running already. Updating the scheduling
  ## of a job is not allowed.
  ## 
  let valid = call_594040.validator(path, query, header, formData, body)
  let scheme = call_594040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594040.url(scheme.get, call_594040.host, call_594040.base,
                         call_594040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594040, url, valid)

proc call*(call_594041: Call_StoragetransferTransferJobsPatch_594024;
          jobName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## storagetransferTransferJobsPatch
  ## Updates a transfer job. Updating a job's transfer spec does not affect
  ## transfer operations that are running already. Updating the scheduling
  ## of a job is not allowed.
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
  ##   jobName: string (required)
  ##          : Required. The name of job to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594042 = newJObject()
  var query_594043 = newJObject()
  var body_594044 = newJObject()
  add(query_594043, "upload_protocol", newJString(uploadProtocol))
  add(query_594043, "fields", newJString(fields))
  add(query_594043, "quotaUser", newJString(quotaUser))
  add(query_594043, "alt", newJString(alt))
  add(query_594043, "oauth_token", newJString(oauthToken))
  add(query_594043, "callback", newJString(callback))
  add(query_594043, "access_token", newJString(accessToken))
  add(query_594043, "uploadType", newJString(uploadType))
  add(path_594042, "jobName", newJString(jobName))
  add(query_594043, "key", newJString(key))
  add(query_594043, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594044 = body
  add(query_594043, "prettyPrint", newJBool(prettyPrint))
  result = call_594041.call(path_594042, query_594043, nil, nil, body_594044)

var storagetransferTransferJobsPatch* = Call_StoragetransferTransferJobsPatch_594024(
    name: "storagetransferTransferJobsPatch", meth: HttpMethod.HttpPatch,
    host: "storagetransfer.googleapis.com", route: "/v1/{jobName}",
    validator: validate_StoragetransferTransferJobsPatch_594025, base: "/",
    url: url_StoragetransferTransferJobsPatch_594026, schemes: {Scheme.Https})
type
  Call_StoragetransferTransferOperationsGet_594045 = ref object of OpenApiRestCall_593408
proc url_StoragetransferTransferOperationsGet_594047(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StoragetransferTransferOperationsGet_594046(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
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
  var valid_594053 = query.getOrDefault("oauth_token")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "oauth_token", valid_594053
  var valid_594054 = query.getOrDefault("callback")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "callback", valid_594054
  var valid_594055 = query.getOrDefault("access_token")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "access_token", valid_594055
  var valid_594056 = query.getOrDefault("uploadType")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "uploadType", valid_594056
  var valid_594057 = query.getOrDefault("key")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "key", valid_594057
  var valid_594058 = query.getOrDefault("$.xgafv")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = newJString("1"))
  if valid_594058 != nil:
    section.add "$.xgafv", valid_594058
  var valid_594059 = query.getOrDefault("prettyPrint")
  valid_594059 = validateParameter(valid_594059, JBool, required = false,
                                 default = newJBool(true))
  if valid_594059 != nil:
    section.add "prettyPrint", valid_594059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594060: Call_StoragetransferTransferOperationsGet_594045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_594060.validator(path, query, header, formData, body)
  let scheme = call_594060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594060.url(scheme.get, call_594060.host, call_594060.base,
                         call_594060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594060, url, valid)

proc call*(call_594061: Call_StoragetransferTransferOperationsGet_594045;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## storagetransferTransferOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
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
  var path_594062 = newJObject()
  var query_594063 = newJObject()
  add(query_594063, "upload_protocol", newJString(uploadProtocol))
  add(query_594063, "fields", newJString(fields))
  add(query_594063, "quotaUser", newJString(quotaUser))
  add(path_594062, "name", newJString(name))
  add(query_594063, "alt", newJString(alt))
  add(query_594063, "oauth_token", newJString(oauthToken))
  add(query_594063, "callback", newJString(callback))
  add(query_594063, "access_token", newJString(accessToken))
  add(query_594063, "uploadType", newJString(uploadType))
  add(query_594063, "key", newJString(key))
  add(query_594063, "$.xgafv", newJString(Xgafv))
  add(query_594063, "prettyPrint", newJBool(prettyPrint))
  result = call_594061.call(path_594062, query_594063, nil, nil, nil)

var storagetransferTransferOperationsGet* = Call_StoragetransferTransferOperationsGet_594045(
    name: "storagetransferTransferOperationsGet", meth: HttpMethod.HttpGet,
    host: "storagetransfer.googleapis.com", route: "/v1/{name}",
    validator: validate_StoragetransferTransferOperationsGet_594046, base: "/",
    url: url_StoragetransferTransferOperationsGet_594047, schemes: {Scheme.Https})
type
  Call_StoragetransferTransferOperationsDelete_594064 = ref object of OpenApiRestCall_593408
proc url_StoragetransferTransferOperationsDelete_594066(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StoragetransferTransferOperationsDelete_594065(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method is not supported and the server returns `UNIMPLEMENTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594067 = path.getOrDefault("name")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "name", valid_594067
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
  var valid_594068 = query.getOrDefault("upload_protocol")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "upload_protocol", valid_594068
  var valid_594069 = query.getOrDefault("fields")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "fields", valid_594069
  var valid_594070 = query.getOrDefault("quotaUser")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "quotaUser", valid_594070
  var valid_594071 = query.getOrDefault("alt")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = newJString("json"))
  if valid_594071 != nil:
    section.add "alt", valid_594071
  var valid_594072 = query.getOrDefault("oauth_token")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "oauth_token", valid_594072
  var valid_594073 = query.getOrDefault("callback")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "callback", valid_594073
  var valid_594074 = query.getOrDefault("access_token")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "access_token", valid_594074
  var valid_594075 = query.getOrDefault("uploadType")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "uploadType", valid_594075
  var valid_594076 = query.getOrDefault("key")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "key", valid_594076
  var valid_594077 = query.getOrDefault("$.xgafv")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = newJString("1"))
  if valid_594077 != nil:
    section.add "$.xgafv", valid_594077
  var valid_594078 = query.getOrDefault("prettyPrint")
  valid_594078 = validateParameter(valid_594078, JBool, required = false,
                                 default = newJBool(true))
  if valid_594078 != nil:
    section.add "prettyPrint", valid_594078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594079: Call_StoragetransferTransferOperationsDelete_594064;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This method is not supported and the server returns `UNIMPLEMENTED`.
  ## 
  let valid = call_594079.validator(path, query, header, formData, body)
  let scheme = call_594079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594079.url(scheme.get, call_594079.host, call_594079.base,
                         call_594079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594079, url, valid)

proc call*(call_594080: Call_StoragetransferTransferOperationsDelete_594064;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## storagetransferTransferOperationsDelete
  ## This method is not supported and the server returns `UNIMPLEMENTED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
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
  var path_594081 = newJObject()
  var query_594082 = newJObject()
  add(query_594082, "upload_protocol", newJString(uploadProtocol))
  add(query_594082, "fields", newJString(fields))
  add(query_594082, "quotaUser", newJString(quotaUser))
  add(path_594081, "name", newJString(name))
  add(query_594082, "alt", newJString(alt))
  add(query_594082, "oauth_token", newJString(oauthToken))
  add(query_594082, "callback", newJString(callback))
  add(query_594082, "access_token", newJString(accessToken))
  add(query_594082, "uploadType", newJString(uploadType))
  add(query_594082, "key", newJString(key))
  add(query_594082, "$.xgafv", newJString(Xgafv))
  add(query_594082, "prettyPrint", newJBool(prettyPrint))
  result = call_594080.call(path_594081, query_594082, nil, nil, nil)

var storagetransferTransferOperationsDelete* = Call_StoragetransferTransferOperationsDelete_594064(
    name: "storagetransferTransferOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "storagetransfer.googleapis.com", route: "/v1/{name}",
    validator: validate_StoragetransferTransferOperationsDelete_594065, base: "/",
    url: url_StoragetransferTransferOperationsDelete_594066,
    schemes: {Scheme.Https})
type
  Call_StoragetransferTransferOperationsCancel_594083 = ref object of OpenApiRestCall_593408
proc url_StoragetransferTransferOperationsCancel_594085(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StoragetransferTransferOperationsCancel_594084(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a transfer. Use the get method to check whether the cancellation succeeded or whether the operation completed despite cancellation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594086 = path.getOrDefault("name")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "name", valid_594086
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
  var valid_594087 = query.getOrDefault("upload_protocol")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "upload_protocol", valid_594087
  var valid_594088 = query.getOrDefault("fields")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "fields", valid_594088
  var valid_594089 = query.getOrDefault("quotaUser")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "quotaUser", valid_594089
  var valid_594090 = query.getOrDefault("alt")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = newJString("json"))
  if valid_594090 != nil:
    section.add "alt", valid_594090
  var valid_594091 = query.getOrDefault("oauth_token")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "oauth_token", valid_594091
  var valid_594092 = query.getOrDefault("callback")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "callback", valid_594092
  var valid_594093 = query.getOrDefault("access_token")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "access_token", valid_594093
  var valid_594094 = query.getOrDefault("uploadType")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "uploadType", valid_594094
  var valid_594095 = query.getOrDefault("key")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "key", valid_594095
  var valid_594096 = query.getOrDefault("$.xgafv")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = newJString("1"))
  if valid_594096 != nil:
    section.add "$.xgafv", valid_594096
  var valid_594097 = query.getOrDefault("prettyPrint")
  valid_594097 = validateParameter(valid_594097, JBool, required = false,
                                 default = newJBool(true))
  if valid_594097 != nil:
    section.add "prettyPrint", valid_594097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594098: Call_StoragetransferTransferOperationsCancel_594083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a transfer. Use the get method to check whether the cancellation succeeded or whether the operation completed despite cancellation.
  ## 
  let valid = call_594098.validator(path, query, header, formData, body)
  let scheme = call_594098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594098.url(scheme.get, call_594098.host, call_594098.base,
                         call_594098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594098, url, valid)

proc call*(call_594099: Call_StoragetransferTransferOperationsCancel_594083;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## storagetransferTransferOperationsCancel
  ## Cancels a transfer. Use the get method to check whether the cancellation succeeded or whether the operation completed despite cancellation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
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
  var path_594100 = newJObject()
  var query_594101 = newJObject()
  add(query_594101, "upload_protocol", newJString(uploadProtocol))
  add(query_594101, "fields", newJString(fields))
  add(query_594101, "quotaUser", newJString(quotaUser))
  add(path_594100, "name", newJString(name))
  add(query_594101, "alt", newJString(alt))
  add(query_594101, "oauth_token", newJString(oauthToken))
  add(query_594101, "callback", newJString(callback))
  add(query_594101, "access_token", newJString(accessToken))
  add(query_594101, "uploadType", newJString(uploadType))
  add(query_594101, "key", newJString(key))
  add(query_594101, "$.xgafv", newJString(Xgafv))
  add(query_594101, "prettyPrint", newJBool(prettyPrint))
  result = call_594099.call(path_594100, query_594101, nil, nil, nil)

var storagetransferTransferOperationsCancel* = Call_StoragetransferTransferOperationsCancel_594083(
    name: "storagetransferTransferOperationsCancel", meth: HttpMethod.HttpPost,
    host: "storagetransfer.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_StoragetransferTransferOperationsCancel_594084, base: "/",
    url: url_StoragetransferTransferOperationsCancel_594085,
    schemes: {Scheme.Https})
type
  Call_StoragetransferTransferOperationsPause_594102 = ref object of OpenApiRestCall_593408
proc url_StoragetransferTransferOperationsPause_594104(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":pause")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StoragetransferTransferOperationsPause_594103(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pauses a transfer operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the transfer operation.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594105 = path.getOrDefault("name")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "name", valid_594105
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
  var valid_594106 = query.getOrDefault("upload_protocol")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "upload_protocol", valid_594106
  var valid_594107 = query.getOrDefault("fields")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "fields", valid_594107
  var valid_594108 = query.getOrDefault("quotaUser")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "quotaUser", valid_594108
  var valid_594109 = query.getOrDefault("alt")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = newJString("json"))
  if valid_594109 != nil:
    section.add "alt", valid_594109
  var valid_594110 = query.getOrDefault("oauth_token")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "oauth_token", valid_594110
  var valid_594111 = query.getOrDefault("callback")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "callback", valid_594111
  var valid_594112 = query.getOrDefault("access_token")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "access_token", valid_594112
  var valid_594113 = query.getOrDefault("uploadType")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "uploadType", valid_594113
  var valid_594114 = query.getOrDefault("key")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "key", valid_594114
  var valid_594115 = query.getOrDefault("$.xgafv")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = newJString("1"))
  if valid_594115 != nil:
    section.add "$.xgafv", valid_594115
  var valid_594116 = query.getOrDefault("prettyPrint")
  valid_594116 = validateParameter(valid_594116, JBool, required = false,
                                 default = newJBool(true))
  if valid_594116 != nil:
    section.add "prettyPrint", valid_594116
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

proc call*(call_594118: Call_StoragetransferTransferOperationsPause_594102;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pauses a transfer operation.
  ## 
  let valid = call_594118.validator(path, query, header, formData, body)
  let scheme = call_594118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594118.url(scheme.get, call_594118.host, call_594118.base,
                         call_594118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594118, url, valid)

proc call*(call_594119: Call_StoragetransferTransferOperationsPause_594102;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## storagetransferTransferOperationsPause
  ## Pauses a transfer operation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the transfer operation.
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
  var path_594120 = newJObject()
  var query_594121 = newJObject()
  var body_594122 = newJObject()
  add(query_594121, "upload_protocol", newJString(uploadProtocol))
  add(query_594121, "fields", newJString(fields))
  add(query_594121, "quotaUser", newJString(quotaUser))
  add(path_594120, "name", newJString(name))
  add(query_594121, "alt", newJString(alt))
  add(query_594121, "oauth_token", newJString(oauthToken))
  add(query_594121, "callback", newJString(callback))
  add(query_594121, "access_token", newJString(accessToken))
  add(query_594121, "uploadType", newJString(uploadType))
  add(query_594121, "key", newJString(key))
  add(query_594121, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594122 = body
  add(query_594121, "prettyPrint", newJBool(prettyPrint))
  result = call_594119.call(path_594120, query_594121, nil, nil, body_594122)

var storagetransferTransferOperationsPause* = Call_StoragetransferTransferOperationsPause_594102(
    name: "storagetransferTransferOperationsPause", meth: HttpMethod.HttpPost,
    host: "storagetransfer.googleapis.com", route: "/v1/{name}:pause",
    validator: validate_StoragetransferTransferOperationsPause_594103, base: "/",
    url: url_StoragetransferTransferOperationsPause_594104,
    schemes: {Scheme.Https})
type
  Call_StoragetransferTransferOperationsResume_594123 = ref object of OpenApiRestCall_593408
proc url_StoragetransferTransferOperationsResume_594125(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":resume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StoragetransferTransferOperationsResume_594124(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resumes a transfer operation that is paused.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the transfer operation.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594126 = path.getOrDefault("name")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "name", valid_594126
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
  var valid_594127 = query.getOrDefault("upload_protocol")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "upload_protocol", valid_594127
  var valid_594128 = query.getOrDefault("fields")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "fields", valid_594128
  var valid_594129 = query.getOrDefault("quotaUser")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "quotaUser", valid_594129
  var valid_594130 = query.getOrDefault("alt")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = newJString("json"))
  if valid_594130 != nil:
    section.add "alt", valid_594130
  var valid_594131 = query.getOrDefault("oauth_token")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "oauth_token", valid_594131
  var valid_594132 = query.getOrDefault("callback")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "callback", valid_594132
  var valid_594133 = query.getOrDefault("access_token")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "access_token", valid_594133
  var valid_594134 = query.getOrDefault("uploadType")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "uploadType", valid_594134
  var valid_594135 = query.getOrDefault("key")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "key", valid_594135
  var valid_594136 = query.getOrDefault("$.xgafv")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = newJString("1"))
  if valid_594136 != nil:
    section.add "$.xgafv", valid_594136
  var valid_594137 = query.getOrDefault("prettyPrint")
  valid_594137 = validateParameter(valid_594137, JBool, required = false,
                                 default = newJBool(true))
  if valid_594137 != nil:
    section.add "prettyPrint", valid_594137
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

proc call*(call_594139: Call_StoragetransferTransferOperationsResume_594123;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resumes a transfer operation that is paused.
  ## 
  let valid = call_594139.validator(path, query, header, formData, body)
  let scheme = call_594139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594139.url(scheme.get, call_594139.host, call_594139.base,
                         call_594139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594139, url, valid)

proc call*(call_594140: Call_StoragetransferTransferOperationsResume_594123;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## storagetransferTransferOperationsResume
  ## Resumes a transfer operation that is paused.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the transfer operation.
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
  var path_594141 = newJObject()
  var query_594142 = newJObject()
  var body_594143 = newJObject()
  add(query_594142, "upload_protocol", newJString(uploadProtocol))
  add(query_594142, "fields", newJString(fields))
  add(query_594142, "quotaUser", newJString(quotaUser))
  add(path_594141, "name", newJString(name))
  add(query_594142, "alt", newJString(alt))
  add(query_594142, "oauth_token", newJString(oauthToken))
  add(query_594142, "callback", newJString(callback))
  add(query_594142, "access_token", newJString(accessToken))
  add(query_594142, "uploadType", newJString(uploadType))
  add(query_594142, "key", newJString(key))
  add(query_594142, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594143 = body
  add(query_594142, "prettyPrint", newJBool(prettyPrint))
  result = call_594140.call(path_594141, query_594142, nil, nil, body_594143)

var storagetransferTransferOperationsResume* = Call_StoragetransferTransferOperationsResume_594123(
    name: "storagetransferTransferOperationsResume", meth: HttpMethod.HttpPost,
    host: "storagetransfer.googleapis.com", route: "/v1/{name}:resume",
    validator: validate_StoragetransferTransferOperationsResume_594124, base: "/",
    url: url_StoragetransferTransferOperationsResume_594125,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
