
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  gcpServiceName = "storagetransfer"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StoragetransferGoogleServiceAccountsGet_578610 = ref object of OpenApiRestCall_578339
proc url_StoragetransferGoogleServiceAccountsGet_578612(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/googleServiceAccounts/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StoragetransferGoogleServiceAccountsGet_578611(path: JsonNode;
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
  var valid_578738 = path.getOrDefault("projectId")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "projectId", valid_578738
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
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("$.xgafv")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("1"))
  if valid_578755 != nil:
    section.add "$.xgafv", valid_578755
  var valid_578756 = query.getOrDefault("alt")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("json"))
  if valid_578756 != nil:
    section.add "alt", valid_578756
  var valid_578757 = query.getOrDefault("uploadType")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "uploadType", valid_578757
  var valid_578758 = query.getOrDefault("quotaUser")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "quotaUser", valid_578758
  var valid_578759 = query.getOrDefault("callback")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "callback", valid_578759
  var valid_578760 = query.getOrDefault("fields")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "fields", valid_578760
  var valid_578761 = query.getOrDefault("access_token")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "access_token", valid_578761
  var valid_578762 = query.getOrDefault("upload_protocol")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "upload_protocol", valid_578762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578785: Call_StoragetransferGoogleServiceAccountsGet_578610;
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
  let valid = call_578785.validator(path, query, header, formData, body)
  let scheme = call_578785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578785.url(scheme.get, call_578785.host, call_578785.base,
                         call_578785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578785, url, valid)

proc call*(call_578856: Call_StoragetransferGoogleServiceAccountsGet_578610;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## storagetransferGoogleServiceAccountsGet
  ## Returns the Google service account that is used by Storage Transfer
  ## Service to access buckets in the project where transfers
  ## run or in other projects. Each Google service account is associated
  ## with one Google Cloud Platform Console project. Users
  ## should add this service account to the Google Cloud Storage bucket
  ## ACLs to grant access to Storage Transfer Service. This service
  ## account is created and owned by Storage Transfer Service and can
  ## only be used by Storage Transfer Service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. The ID of the Google Cloud Platform Console project that the
  ## Google service account is associated with.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578857 = newJObject()
  var query_578859 = newJObject()
  add(query_578859, "key", newJString(key))
  add(query_578859, "prettyPrint", newJBool(prettyPrint))
  add(query_578859, "oauth_token", newJString(oauthToken))
  add(path_578857, "projectId", newJString(projectId))
  add(query_578859, "$.xgafv", newJString(Xgafv))
  add(query_578859, "alt", newJString(alt))
  add(query_578859, "uploadType", newJString(uploadType))
  add(query_578859, "quotaUser", newJString(quotaUser))
  add(query_578859, "callback", newJString(callback))
  add(query_578859, "fields", newJString(fields))
  add(query_578859, "access_token", newJString(accessToken))
  add(query_578859, "upload_protocol", newJString(uploadProtocol))
  result = call_578856.call(path_578857, query_578859, nil, nil, nil)

var storagetransferGoogleServiceAccountsGet* = Call_StoragetransferGoogleServiceAccountsGet_578610(
    name: "storagetransferGoogleServiceAccountsGet", meth: HttpMethod.HttpGet,
    host: "storagetransfer.googleapis.com",
    route: "/v1/googleServiceAccounts/{projectId}",
    validator: validate_StoragetransferGoogleServiceAccountsGet_578611, base: "/",
    url: url_StoragetransferGoogleServiceAccountsGet_578612,
    schemes: {Scheme.Https})
type
  Call_StoragetransferTransferJobsCreate_578918 = ref object of OpenApiRestCall_578339
proc url_StoragetransferTransferJobsCreate_578920(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StoragetransferTransferJobsCreate_578919(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a transfer job that runs periodically.
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
  var valid_578921 = query.getOrDefault("key")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "key", valid_578921
  var valid_578922 = query.getOrDefault("prettyPrint")
  valid_578922 = validateParameter(valid_578922, JBool, required = false,
                                 default = newJBool(true))
  if valid_578922 != nil:
    section.add "prettyPrint", valid_578922
  var valid_578923 = query.getOrDefault("oauth_token")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "oauth_token", valid_578923
  var valid_578924 = query.getOrDefault("$.xgafv")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = newJString("1"))
  if valid_578924 != nil:
    section.add "$.xgafv", valid_578924
  var valid_578925 = query.getOrDefault("alt")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = newJString("json"))
  if valid_578925 != nil:
    section.add "alt", valid_578925
  var valid_578926 = query.getOrDefault("uploadType")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "uploadType", valid_578926
  var valid_578927 = query.getOrDefault("quotaUser")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "quotaUser", valid_578927
  var valid_578928 = query.getOrDefault("callback")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "callback", valid_578928
  var valid_578929 = query.getOrDefault("fields")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "fields", valid_578929
  var valid_578930 = query.getOrDefault("access_token")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "access_token", valid_578930
  var valid_578931 = query.getOrDefault("upload_protocol")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "upload_protocol", valid_578931
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

proc call*(call_578933: Call_StoragetransferTransferJobsCreate_578918;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a transfer job that runs periodically.
  ## 
  let valid = call_578933.validator(path, query, header, formData, body)
  let scheme = call_578933.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578933.url(scheme.get, call_578933.host, call_578933.base,
                         call_578933.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578933, url, valid)

proc call*(call_578934: Call_StoragetransferTransferJobsCreate_578918;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## storagetransferTransferJobsCreate
  ## Creates a transfer job that runs periodically.
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
  var query_578935 = newJObject()
  var body_578936 = newJObject()
  add(query_578935, "key", newJString(key))
  add(query_578935, "prettyPrint", newJBool(prettyPrint))
  add(query_578935, "oauth_token", newJString(oauthToken))
  add(query_578935, "$.xgafv", newJString(Xgafv))
  add(query_578935, "alt", newJString(alt))
  add(query_578935, "uploadType", newJString(uploadType))
  add(query_578935, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578936 = body
  add(query_578935, "callback", newJString(callback))
  add(query_578935, "fields", newJString(fields))
  add(query_578935, "access_token", newJString(accessToken))
  add(query_578935, "upload_protocol", newJString(uploadProtocol))
  result = call_578934.call(nil, query_578935, nil, nil, body_578936)

var storagetransferTransferJobsCreate* = Call_StoragetransferTransferJobsCreate_578918(
    name: "storagetransferTransferJobsCreate", meth: HttpMethod.HttpPost,
    host: "storagetransfer.googleapis.com", route: "/v1/transferJobs",
    validator: validate_StoragetransferTransferJobsCreate_578919, base: "/",
    url: url_StoragetransferTransferJobsCreate_578920, schemes: {Scheme.Https})
type
  Call_StoragetransferTransferJobsList_578898 = ref object of OpenApiRestCall_578339
proc url_StoragetransferTransferJobsList_578900(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StoragetransferTransferJobsList_578899(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists transfer jobs.
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
  ##   pageSize: JInt
  ##           : The list page size. The max allowed value is 256.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Required. A list of query parameters specified as JSON text in the form of:
  ## {"project_id":"my_project_id",
  ##  "job_names":["jobid1","jobid2",...],
  ##  "job_statuses":["status1","status2",...]}.
  ## Since `job_names` and `job_statuses` support multiple values, their values
  ## must be specified with array notation. `project_id` is required.
  ## `job_names` and `job_statuses` are optional.  The valid values for
  ## `job_statuses` are case-insensitive: `ENABLED`, `DISABLED`, and `DELETED`.
  ##   pageToken: JString
  ##            : The list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578901 = query.getOrDefault("key")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "key", valid_578901
  var valid_578902 = query.getOrDefault("prettyPrint")
  valid_578902 = validateParameter(valid_578902, JBool, required = false,
                                 default = newJBool(true))
  if valid_578902 != nil:
    section.add "prettyPrint", valid_578902
  var valid_578903 = query.getOrDefault("oauth_token")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "oauth_token", valid_578903
  var valid_578904 = query.getOrDefault("$.xgafv")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = newJString("1"))
  if valid_578904 != nil:
    section.add "$.xgafv", valid_578904
  var valid_578905 = query.getOrDefault("pageSize")
  valid_578905 = validateParameter(valid_578905, JInt, required = false, default = nil)
  if valid_578905 != nil:
    section.add "pageSize", valid_578905
  var valid_578906 = query.getOrDefault("alt")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = newJString("json"))
  if valid_578906 != nil:
    section.add "alt", valid_578906
  var valid_578907 = query.getOrDefault("uploadType")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "uploadType", valid_578907
  var valid_578908 = query.getOrDefault("quotaUser")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "quotaUser", valid_578908
  var valid_578909 = query.getOrDefault("filter")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "filter", valid_578909
  var valid_578910 = query.getOrDefault("pageToken")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "pageToken", valid_578910
  var valid_578911 = query.getOrDefault("callback")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "callback", valid_578911
  var valid_578912 = query.getOrDefault("fields")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "fields", valid_578912
  var valid_578913 = query.getOrDefault("access_token")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "access_token", valid_578913
  var valid_578914 = query.getOrDefault("upload_protocol")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "upload_protocol", valid_578914
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578915: Call_StoragetransferTransferJobsList_578898;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists transfer jobs.
  ## 
  let valid = call_578915.validator(path, query, header, formData, body)
  let scheme = call_578915.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578915.url(scheme.get, call_578915.host, call_578915.base,
                         call_578915.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578915, url, valid)

proc call*(call_578916: Call_StoragetransferTransferJobsList_578898;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## storagetransferTransferJobsList
  ## Lists transfer jobs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The list page size. The max allowed value is 256.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Required. A list of query parameters specified as JSON text in the form of:
  ## {"project_id":"my_project_id",
  ##  "job_names":["jobid1","jobid2",...],
  ##  "job_statuses":["status1","status2",...]}.
  ## Since `job_names` and `job_statuses` support multiple values, their values
  ## must be specified with array notation. `project_id` is required.
  ## `job_names` and `job_statuses` are optional.  The valid values for
  ## `job_statuses` are case-insensitive: `ENABLED`, `DISABLED`, and `DELETED`.
  ##   pageToken: string
  ##            : The list page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578917 = newJObject()
  add(query_578917, "key", newJString(key))
  add(query_578917, "prettyPrint", newJBool(prettyPrint))
  add(query_578917, "oauth_token", newJString(oauthToken))
  add(query_578917, "$.xgafv", newJString(Xgafv))
  add(query_578917, "pageSize", newJInt(pageSize))
  add(query_578917, "alt", newJString(alt))
  add(query_578917, "uploadType", newJString(uploadType))
  add(query_578917, "quotaUser", newJString(quotaUser))
  add(query_578917, "filter", newJString(filter))
  add(query_578917, "pageToken", newJString(pageToken))
  add(query_578917, "callback", newJString(callback))
  add(query_578917, "fields", newJString(fields))
  add(query_578917, "access_token", newJString(accessToken))
  add(query_578917, "upload_protocol", newJString(uploadProtocol))
  result = call_578916.call(nil, query_578917, nil, nil, nil)

var storagetransferTransferJobsList* = Call_StoragetransferTransferJobsList_578898(
    name: "storagetransferTransferJobsList", meth: HttpMethod.HttpGet,
    host: "storagetransfer.googleapis.com", route: "/v1/transferJobs",
    validator: validate_StoragetransferTransferJobsList_578899, base: "/",
    url: url_StoragetransferTransferJobsList_578900, schemes: {Scheme.Https})
type
  Call_StoragetransferTransferJobsGet_578937 = ref object of OpenApiRestCall_578339
proc url_StoragetransferTransferJobsGet_578939(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StoragetransferTransferJobsGet_578938(path: JsonNode;
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
  var valid_578940 = path.getOrDefault("jobName")
  valid_578940 = validateParameter(valid_578940, JString, required = true,
                                 default = nil)
  if valid_578940 != nil:
    section.add "jobName", valid_578940
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
  ##   projectId: JString
  ##            : Required. The ID of the Google Cloud Platform Console project that owns the
  ## job.
  section = newJObject()
  var valid_578941 = query.getOrDefault("key")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "key", valid_578941
  var valid_578942 = query.getOrDefault("prettyPrint")
  valid_578942 = validateParameter(valid_578942, JBool, required = false,
                                 default = newJBool(true))
  if valid_578942 != nil:
    section.add "prettyPrint", valid_578942
  var valid_578943 = query.getOrDefault("oauth_token")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "oauth_token", valid_578943
  var valid_578944 = query.getOrDefault("$.xgafv")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = newJString("1"))
  if valid_578944 != nil:
    section.add "$.xgafv", valid_578944
  var valid_578945 = query.getOrDefault("alt")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = newJString("json"))
  if valid_578945 != nil:
    section.add "alt", valid_578945
  var valid_578946 = query.getOrDefault("uploadType")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "uploadType", valid_578946
  var valid_578947 = query.getOrDefault("quotaUser")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "quotaUser", valid_578947
  var valid_578948 = query.getOrDefault("callback")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "callback", valid_578948
  var valid_578949 = query.getOrDefault("fields")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "fields", valid_578949
  var valid_578950 = query.getOrDefault("access_token")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "access_token", valid_578950
  var valid_578951 = query.getOrDefault("upload_protocol")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "upload_protocol", valid_578951
  var valid_578952 = query.getOrDefault("projectId")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "projectId", valid_578952
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578953: Call_StoragetransferTransferJobsGet_578937; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a transfer job.
  ## 
  let valid = call_578953.validator(path, query, header, formData, body)
  let scheme = call_578953.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578953.url(scheme.get, call_578953.host, call_578953.base,
                         call_578953.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578953, url, valid)

proc call*(call_578954: Call_StoragetransferTransferJobsGet_578937;
          jobName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          projectId: string = ""): Recallable =
  ## storagetransferTransferJobsGet
  ## Gets a transfer job.
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: string
  ##            : Required. The ID of the Google Cloud Platform Console project that owns the
  ## job.
  ##   jobName: string (required)
  ##          : Required. The job to get.
  var path_578955 = newJObject()
  var query_578956 = newJObject()
  add(query_578956, "key", newJString(key))
  add(query_578956, "prettyPrint", newJBool(prettyPrint))
  add(query_578956, "oauth_token", newJString(oauthToken))
  add(query_578956, "$.xgafv", newJString(Xgafv))
  add(query_578956, "alt", newJString(alt))
  add(query_578956, "uploadType", newJString(uploadType))
  add(query_578956, "quotaUser", newJString(quotaUser))
  add(query_578956, "callback", newJString(callback))
  add(query_578956, "fields", newJString(fields))
  add(query_578956, "access_token", newJString(accessToken))
  add(query_578956, "upload_protocol", newJString(uploadProtocol))
  add(query_578956, "projectId", newJString(projectId))
  add(path_578955, "jobName", newJString(jobName))
  result = call_578954.call(path_578955, query_578956, nil, nil, nil)

var storagetransferTransferJobsGet* = Call_StoragetransferTransferJobsGet_578937(
    name: "storagetransferTransferJobsGet", meth: HttpMethod.HttpGet,
    host: "storagetransfer.googleapis.com", route: "/v1/{jobName}",
    validator: validate_StoragetransferTransferJobsGet_578938, base: "/",
    url: url_StoragetransferTransferJobsGet_578939, schemes: {Scheme.Https})
type
  Call_StoragetransferTransferJobsPatch_578957 = ref object of OpenApiRestCall_578339
proc url_StoragetransferTransferJobsPatch_578959(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StoragetransferTransferJobsPatch_578958(path: JsonNode;
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
  var valid_578960 = path.getOrDefault("jobName")
  valid_578960 = validateParameter(valid_578960, JString, required = true,
                                 default = nil)
  if valid_578960 != nil:
    section.add "jobName", valid_578960
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
  var valid_578961 = query.getOrDefault("key")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "key", valid_578961
  var valid_578962 = query.getOrDefault("prettyPrint")
  valid_578962 = validateParameter(valid_578962, JBool, required = false,
                                 default = newJBool(true))
  if valid_578962 != nil:
    section.add "prettyPrint", valid_578962
  var valid_578963 = query.getOrDefault("oauth_token")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "oauth_token", valid_578963
  var valid_578964 = query.getOrDefault("$.xgafv")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = newJString("1"))
  if valid_578964 != nil:
    section.add "$.xgafv", valid_578964
  var valid_578965 = query.getOrDefault("alt")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = newJString("json"))
  if valid_578965 != nil:
    section.add "alt", valid_578965
  var valid_578966 = query.getOrDefault("uploadType")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "uploadType", valid_578966
  var valid_578967 = query.getOrDefault("quotaUser")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "quotaUser", valid_578967
  var valid_578968 = query.getOrDefault("callback")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "callback", valid_578968
  var valid_578969 = query.getOrDefault("fields")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "fields", valid_578969
  var valid_578970 = query.getOrDefault("access_token")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "access_token", valid_578970
  var valid_578971 = query.getOrDefault("upload_protocol")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "upload_protocol", valid_578971
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

proc call*(call_578973: Call_StoragetransferTransferJobsPatch_578957;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a transfer job. Updating a job's transfer spec does not affect
  ## transfer operations that are running already. Updating the scheduling
  ## of a job is not allowed.
  ## 
  let valid = call_578973.validator(path, query, header, formData, body)
  let scheme = call_578973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578973.url(scheme.get, call_578973.host, call_578973.base,
                         call_578973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578973, url, valid)

proc call*(call_578974: Call_StoragetransferTransferJobsPatch_578957;
          jobName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## storagetransferTransferJobsPatch
  ## Updates a transfer job. Updating a job's transfer spec does not affect
  ## transfer operations that are running already. Updating the scheduling
  ## of a job is not allowed.
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
  ##   jobName: string (required)
  ##          : Required. The name of job to update.
  var path_578975 = newJObject()
  var query_578976 = newJObject()
  var body_578977 = newJObject()
  add(query_578976, "key", newJString(key))
  add(query_578976, "prettyPrint", newJBool(prettyPrint))
  add(query_578976, "oauth_token", newJString(oauthToken))
  add(query_578976, "$.xgafv", newJString(Xgafv))
  add(query_578976, "alt", newJString(alt))
  add(query_578976, "uploadType", newJString(uploadType))
  add(query_578976, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578977 = body
  add(query_578976, "callback", newJString(callback))
  add(query_578976, "fields", newJString(fields))
  add(query_578976, "access_token", newJString(accessToken))
  add(query_578976, "upload_protocol", newJString(uploadProtocol))
  add(path_578975, "jobName", newJString(jobName))
  result = call_578974.call(path_578975, query_578976, nil, nil, body_578977)

var storagetransferTransferJobsPatch* = Call_StoragetransferTransferJobsPatch_578957(
    name: "storagetransferTransferJobsPatch", meth: HttpMethod.HttpPatch,
    host: "storagetransfer.googleapis.com", route: "/v1/{jobName}",
    validator: validate_StoragetransferTransferJobsPatch_578958, base: "/",
    url: url_StoragetransferTransferJobsPatch_578959, schemes: {Scheme.Https})
type
  Call_StoragetransferTransferOperationsGet_578978 = ref object of OpenApiRestCall_578339
proc url_StoragetransferTransferOperationsGet_578980(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StoragetransferTransferOperationsGet_578979(path: JsonNode;
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
  var valid_578981 = path.getOrDefault("name")
  valid_578981 = validateParameter(valid_578981, JString, required = true,
                                 default = nil)
  if valid_578981 != nil:
    section.add "name", valid_578981
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
  var valid_578982 = query.getOrDefault("key")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "key", valid_578982
  var valid_578983 = query.getOrDefault("prettyPrint")
  valid_578983 = validateParameter(valid_578983, JBool, required = false,
                                 default = newJBool(true))
  if valid_578983 != nil:
    section.add "prettyPrint", valid_578983
  var valid_578984 = query.getOrDefault("oauth_token")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "oauth_token", valid_578984
  var valid_578985 = query.getOrDefault("$.xgafv")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = newJString("1"))
  if valid_578985 != nil:
    section.add "$.xgafv", valid_578985
  var valid_578986 = query.getOrDefault("alt")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = newJString("json"))
  if valid_578986 != nil:
    section.add "alt", valid_578986
  var valid_578987 = query.getOrDefault("uploadType")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "uploadType", valid_578987
  var valid_578988 = query.getOrDefault("quotaUser")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "quotaUser", valid_578988
  var valid_578989 = query.getOrDefault("callback")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "callback", valid_578989
  var valid_578990 = query.getOrDefault("fields")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "fields", valid_578990
  var valid_578991 = query.getOrDefault("access_token")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "access_token", valid_578991
  var valid_578992 = query.getOrDefault("upload_protocol")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "upload_protocol", valid_578992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578993: Call_StoragetransferTransferOperationsGet_578978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_578993.validator(path, query, header, formData, body)
  let scheme = call_578993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578993.url(scheme.get, call_578993.host, call_578993.base,
                         call_578993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578993, url, valid)

proc call*(call_578994: Call_StoragetransferTransferOperationsGet_578978;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## storagetransferTransferOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
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
  ##       : The name of the operation resource.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578995 = newJObject()
  var query_578996 = newJObject()
  add(query_578996, "key", newJString(key))
  add(query_578996, "prettyPrint", newJBool(prettyPrint))
  add(query_578996, "oauth_token", newJString(oauthToken))
  add(query_578996, "$.xgafv", newJString(Xgafv))
  add(query_578996, "alt", newJString(alt))
  add(query_578996, "uploadType", newJString(uploadType))
  add(query_578996, "quotaUser", newJString(quotaUser))
  add(path_578995, "name", newJString(name))
  add(query_578996, "callback", newJString(callback))
  add(query_578996, "fields", newJString(fields))
  add(query_578996, "access_token", newJString(accessToken))
  add(query_578996, "upload_protocol", newJString(uploadProtocol))
  result = call_578994.call(path_578995, query_578996, nil, nil, nil)

var storagetransferTransferOperationsGet* = Call_StoragetransferTransferOperationsGet_578978(
    name: "storagetransferTransferOperationsGet", meth: HttpMethod.HttpGet,
    host: "storagetransfer.googleapis.com", route: "/v1/{name}",
    validator: validate_StoragetransferTransferOperationsGet_578979, base: "/",
    url: url_StoragetransferTransferOperationsGet_578980, schemes: {Scheme.Https})
type
  Call_StoragetransferTransferOperationsDelete_578997 = ref object of OpenApiRestCall_578339
proc url_StoragetransferTransferOperationsDelete_578999(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StoragetransferTransferOperationsDelete_578998(path: JsonNode;
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
  var valid_579000 = path.getOrDefault("name")
  valid_579000 = validateParameter(valid_579000, JString, required = true,
                                 default = nil)
  if valid_579000 != nil:
    section.add "name", valid_579000
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
  var valid_579001 = query.getOrDefault("key")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "key", valid_579001
  var valid_579002 = query.getOrDefault("prettyPrint")
  valid_579002 = validateParameter(valid_579002, JBool, required = false,
                                 default = newJBool(true))
  if valid_579002 != nil:
    section.add "prettyPrint", valid_579002
  var valid_579003 = query.getOrDefault("oauth_token")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "oauth_token", valid_579003
  var valid_579004 = query.getOrDefault("$.xgafv")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = newJString("1"))
  if valid_579004 != nil:
    section.add "$.xgafv", valid_579004
  var valid_579005 = query.getOrDefault("alt")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = newJString("json"))
  if valid_579005 != nil:
    section.add "alt", valid_579005
  var valid_579006 = query.getOrDefault("uploadType")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "uploadType", valid_579006
  var valid_579007 = query.getOrDefault("quotaUser")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "quotaUser", valid_579007
  var valid_579008 = query.getOrDefault("callback")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "callback", valid_579008
  var valid_579009 = query.getOrDefault("fields")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "fields", valid_579009
  var valid_579010 = query.getOrDefault("access_token")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "access_token", valid_579010
  var valid_579011 = query.getOrDefault("upload_protocol")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "upload_protocol", valid_579011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579012: Call_StoragetransferTransferOperationsDelete_578997;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This method is not supported and the server returns `UNIMPLEMENTED`.
  ## 
  let valid = call_579012.validator(path, query, header, formData, body)
  let scheme = call_579012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579012.url(scheme.get, call_579012.host, call_579012.base,
                         call_579012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579012, url, valid)

proc call*(call_579013: Call_StoragetransferTransferOperationsDelete_578997;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## storagetransferTransferOperationsDelete
  ## This method is not supported and the server returns `UNIMPLEMENTED`.
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
  ##       : The name of the operation resource to be deleted.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579014 = newJObject()
  var query_579015 = newJObject()
  add(query_579015, "key", newJString(key))
  add(query_579015, "prettyPrint", newJBool(prettyPrint))
  add(query_579015, "oauth_token", newJString(oauthToken))
  add(query_579015, "$.xgafv", newJString(Xgafv))
  add(query_579015, "alt", newJString(alt))
  add(query_579015, "uploadType", newJString(uploadType))
  add(query_579015, "quotaUser", newJString(quotaUser))
  add(path_579014, "name", newJString(name))
  add(query_579015, "callback", newJString(callback))
  add(query_579015, "fields", newJString(fields))
  add(query_579015, "access_token", newJString(accessToken))
  add(query_579015, "upload_protocol", newJString(uploadProtocol))
  result = call_579013.call(path_579014, query_579015, nil, nil, nil)

var storagetransferTransferOperationsDelete* = Call_StoragetransferTransferOperationsDelete_578997(
    name: "storagetransferTransferOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "storagetransfer.googleapis.com", route: "/v1/{name}",
    validator: validate_StoragetransferTransferOperationsDelete_578998, base: "/",
    url: url_StoragetransferTransferOperationsDelete_578999,
    schemes: {Scheme.Https})
type
  Call_StoragetransferTransferOperationsCancel_579016 = ref object of OpenApiRestCall_578339
proc url_StoragetransferTransferOperationsCancel_579018(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_StoragetransferTransferOperationsCancel_579017(path: JsonNode;
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
  var valid_579019 = path.getOrDefault("name")
  valid_579019 = validateParameter(valid_579019, JString, required = true,
                                 default = nil)
  if valid_579019 != nil:
    section.add "name", valid_579019
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
  var valid_579020 = query.getOrDefault("key")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "key", valid_579020
  var valid_579021 = query.getOrDefault("prettyPrint")
  valid_579021 = validateParameter(valid_579021, JBool, required = false,
                                 default = newJBool(true))
  if valid_579021 != nil:
    section.add "prettyPrint", valid_579021
  var valid_579022 = query.getOrDefault("oauth_token")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "oauth_token", valid_579022
  var valid_579023 = query.getOrDefault("$.xgafv")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = newJString("1"))
  if valid_579023 != nil:
    section.add "$.xgafv", valid_579023
  var valid_579024 = query.getOrDefault("alt")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = newJString("json"))
  if valid_579024 != nil:
    section.add "alt", valid_579024
  var valid_579025 = query.getOrDefault("uploadType")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "uploadType", valid_579025
  var valid_579026 = query.getOrDefault("quotaUser")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "quotaUser", valid_579026
  var valid_579027 = query.getOrDefault("callback")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "callback", valid_579027
  var valid_579028 = query.getOrDefault("fields")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "fields", valid_579028
  var valid_579029 = query.getOrDefault("access_token")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "access_token", valid_579029
  var valid_579030 = query.getOrDefault("upload_protocol")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "upload_protocol", valid_579030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579031: Call_StoragetransferTransferOperationsCancel_579016;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a transfer. Use the get method to check whether the cancellation succeeded or whether the operation completed despite cancellation.
  ## 
  let valid = call_579031.validator(path, query, header, formData, body)
  let scheme = call_579031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579031.url(scheme.get, call_579031.host, call_579031.base,
                         call_579031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579031, url, valid)

proc call*(call_579032: Call_StoragetransferTransferOperationsCancel_579016;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## storagetransferTransferOperationsCancel
  ## Cancels a transfer. Use the get method to check whether the cancellation succeeded or whether the operation completed despite cancellation.
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
  ##       : The name of the operation resource to be cancelled.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579033 = newJObject()
  var query_579034 = newJObject()
  add(query_579034, "key", newJString(key))
  add(query_579034, "prettyPrint", newJBool(prettyPrint))
  add(query_579034, "oauth_token", newJString(oauthToken))
  add(query_579034, "$.xgafv", newJString(Xgafv))
  add(query_579034, "alt", newJString(alt))
  add(query_579034, "uploadType", newJString(uploadType))
  add(query_579034, "quotaUser", newJString(quotaUser))
  add(path_579033, "name", newJString(name))
  add(query_579034, "callback", newJString(callback))
  add(query_579034, "fields", newJString(fields))
  add(query_579034, "access_token", newJString(accessToken))
  add(query_579034, "upload_protocol", newJString(uploadProtocol))
  result = call_579032.call(path_579033, query_579034, nil, nil, nil)

var storagetransferTransferOperationsCancel* = Call_StoragetransferTransferOperationsCancel_579016(
    name: "storagetransferTransferOperationsCancel", meth: HttpMethod.HttpPost,
    host: "storagetransfer.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_StoragetransferTransferOperationsCancel_579017, base: "/",
    url: url_StoragetransferTransferOperationsCancel_579018,
    schemes: {Scheme.Https})
type
  Call_StoragetransferTransferOperationsPause_579035 = ref object of OpenApiRestCall_578339
proc url_StoragetransferTransferOperationsPause_579037(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_StoragetransferTransferOperationsPause_579036(path: JsonNode;
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
  var valid_579038 = path.getOrDefault("name")
  valid_579038 = validateParameter(valid_579038, JString, required = true,
                                 default = nil)
  if valid_579038 != nil:
    section.add "name", valid_579038
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
  var valid_579039 = query.getOrDefault("key")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "key", valid_579039
  var valid_579040 = query.getOrDefault("prettyPrint")
  valid_579040 = validateParameter(valid_579040, JBool, required = false,
                                 default = newJBool(true))
  if valid_579040 != nil:
    section.add "prettyPrint", valid_579040
  var valid_579041 = query.getOrDefault("oauth_token")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "oauth_token", valid_579041
  var valid_579042 = query.getOrDefault("$.xgafv")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = newJString("1"))
  if valid_579042 != nil:
    section.add "$.xgafv", valid_579042
  var valid_579043 = query.getOrDefault("alt")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = newJString("json"))
  if valid_579043 != nil:
    section.add "alt", valid_579043
  var valid_579044 = query.getOrDefault("uploadType")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "uploadType", valid_579044
  var valid_579045 = query.getOrDefault("quotaUser")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "quotaUser", valid_579045
  var valid_579046 = query.getOrDefault("callback")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "callback", valid_579046
  var valid_579047 = query.getOrDefault("fields")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "fields", valid_579047
  var valid_579048 = query.getOrDefault("access_token")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "access_token", valid_579048
  var valid_579049 = query.getOrDefault("upload_protocol")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "upload_protocol", valid_579049
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

proc call*(call_579051: Call_StoragetransferTransferOperationsPause_579035;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pauses a transfer operation.
  ## 
  let valid = call_579051.validator(path, query, header, formData, body)
  let scheme = call_579051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579051.url(scheme.get, call_579051.host, call_579051.base,
                         call_579051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579051, url, valid)

proc call*(call_579052: Call_StoragetransferTransferOperationsPause_579035;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## storagetransferTransferOperationsPause
  ## Pauses a transfer operation.
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
  ##       : Required. The name of the transfer operation.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579053 = newJObject()
  var query_579054 = newJObject()
  var body_579055 = newJObject()
  add(query_579054, "key", newJString(key))
  add(query_579054, "prettyPrint", newJBool(prettyPrint))
  add(query_579054, "oauth_token", newJString(oauthToken))
  add(query_579054, "$.xgafv", newJString(Xgafv))
  add(query_579054, "alt", newJString(alt))
  add(query_579054, "uploadType", newJString(uploadType))
  add(query_579054, "quotaUser", newJString(quotaUser))
  add(path_579053, "name", newJString(name))
  if body != nil:
    body_579055 = body
  add(query_579054, "callback", newJString(callback))
  add(query_579054, "fields", newJString(fields))
  add(query_579054, "access_token", newJString(accessToken))
  add(query_579054, "upload_protocol", newJString(uploadProtocol))
  result = call_579052.call(path_579053, query_579054, nil, nil, body_579055)

var storagetransferTransferOperationsPause* = Call_StoragetransferTransferOperationsPause_579035(
    name: "storagetransferTransferOperationsPause", meth: HttpMethod.HttpPost,
    host: "storagetransfer.googleapis.com", route: "/v1/{name}:pause",
    validator: validate_StoragetransferTransferOperationsPause_579036, base: "/",
    url: url_StoragetransferTransferOperationsPause_579037,
    schemes: {Scheme.Https})
type
  Call_StoragetransferTransferOperationsResume_579056 = ref object of OpenApiRestCall_578339
proc url_StoragetransferTransferOperationsResume_579058(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_StoragetransferTransferOperationsResume_579057(path: JsonNode;
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
  var valid_579059 = path.getOrDefault("name")
  valid_579059 = validateParameter(valid_579059, JString, required = true,
                                 default = nil)
  if valid_579059 != nil:
    section.add "name", valid_579059
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
  var valid_579060 = query.getOrDefault("key")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "key", valid_579060
  var valid_579061 = query.getOrDefault("prettyPrint")
  valid_579061 = validateParameter(valid_579061, JBool, required = false,
                                 default = newJBool(true))
  if valid_579061 != nil:
    section.add "prettyPrint", valid_579061
  var valid_579062 = query.getOrDefault("oauth_token")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "oauth_token", valid_579062
  var valid_579063 = query.getOrDefault("$.xgafv")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = newJString("1"))
  if valid_579063 != nil:
    section.add "$.xgafv", valid_579063
  var valid_579064 = query.getOrDefault("alt")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = newJString("json"))
  if valid_579064 != nil:
    section.add "alt", valid_579064
  var valid_579065 = query.getOrDefault("uploadType")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "uploadType", valid_579065
  var valid_579066 = query.getOrDefault("quotaUser")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "quotaUser", valid_579066
  var valid_579067 = query.getOrDefault("callback")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "callback", valid_579067
  var valid_579068 = query.getOrDefault("fields")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "fields", valid_579068
  var valid_579069 = query.getOrDefault("access_token")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "access_token", valid_579069
  var valid_579070 = query.getOrDefault("upload_protocol")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "upload_protocol", valid_579070
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

proc call*(call_579072: Call_StoragetransferTransferOperationsResume_579056;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resumes a transfer operation that is paused.
  ## 
  let valid = call_579072.validator(path, query, header, formData, body)
  let scheme = call_579072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579072.url(scheme.get, call_579072.host, call_579072.base,
                         call_579072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579072, url, valid)

proc call*(call_579073: Call_StoragetransferTransferOperationsResume_579056;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## storagetransferTransferOperationsResume
  ## Resumes a transfer operation that is paused.
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
  ##       : Required. The name of the transfer operation.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579074 = newJObject()
  var query_579075 = newJObject()
  var body_579076 = newJObject()
  add(query_579075, "key", newJString(key))
  add(query_579075, "prettyPrint", newJBool(prettyPrint))
  add(query_579075, "oauth_token", newJString(oauthToken))
  add(query_579075, "$.xgafv", newJString(Xgafv))
  add(query_579075, "alt", newJString(alt))
  add(query_579075, "uploadType", newJString(uploadType))
  add(query_579075, "quotaUser", newJString(quotaUser))
  add(path_579074, "name", newJString(name))
  if body != nil:
    body_579076 = body
  add(query_579075, "callback", newJString(callback))
  add(query_579075, "fields", newJString(fields))
  add(query_579075, "access_token", newJString(accessToken))
  add(query_579075, "upload_protocol", newJString(uploadProtocol))
  result = call_579073.call(path_579074, query_579075, nil, nil, body_579076)

var storagetransferTransferOperationsResume* = Call_StoragetransferTransferOperationsResume_579056(
    name: "storagetransferTransferOperationsResume", meth: HttpMethod.HttpPost,
    host: "storagetransfer.googleapis.com", route: "/v1/{name}:resume",
    validator: validate_StoragetransferTransferOperationsResume_579057, base: "/",
    url: url_StoragetransferTransferOperationsResume_579058,
    schemes: {Scheme.Https})
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
