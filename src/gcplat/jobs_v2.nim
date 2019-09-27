
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud Talent Solution
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Cloud Talent Solution provides the capability to create, read, update, and delete job postings, as well as search jobs based on keywords and filters.
## 
## 
## https://cloud.google.com/talent-solution/job-search/docs/
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
  gcpServiceName = "jobs"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_JobsCompaniesCreate_593965 = ref object of OpenApiRestCall_593421
proc url_JobsCompaniesCreate_593967(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobsCompaniesCreate_593966(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a new company entity.
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
  var valid_593970 = query.getOrDefault("quotaUser")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "quotaUser", valid_593970
  var valid_593971 = query.getOrDefault("alt")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = newJString("json"))
  if valid_593971 != nil:
    section.add "alt", valid_593971
  var valid_593972 = query.getOrDefault("oauth_token")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "oauth_token", valid_593972
  var valid_593973 = query.getOrDefault("callback")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "callback", valid_593973
  var valid_593974 = query.getOrDefault("access_token")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "access_token", valid_593974
  var valid_593975 = query.getOrDefault("uploadType")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "uploadType", valid_593975
  var valid_593976 = query.getOrDefault("key")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "key", valid_593976
  var valid_593977 = query.getOrDefault("$.xgafv")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = newJString("1"))
  if valid_593977 != nil:
    section.add "$.xgafv", valid_593977
  var valid_593978 = query.getOrDefault("prettyPrint")
  valid_593978 = validateParameter(valid_593978, JBool, required = false,
                                 default = newJBool(true))
  if valid_593978 != nil:
    section.add "prettyPrint", valid_593978
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

proc call*(call_593980: Call_JobsCompaniesCreate_593965; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new company entity.
  ## 
  let valid = call_593980.validator(path, query, header, formData, body)
  let scheme = call_593980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593980.url(scheme.get, call_593980.host, call_593980.base,
                         call_593980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593980, url, valid)

proc call*(call_593981: Call_JobsCompaniesCreate_593965;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsCompaniesCreate
  ## Creates a new company entity.
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
  var query_593982 = newJObject()
  var body_593983 = newJObject()
  add(query_593982, "upload_protocol", newJString(uploadProtocol))
  add(query_593982, "fields", newJString(fields))
  add(query_593982, "quotaUser", newJString(quotaUser))
  add(query_593982, "alt", newJString(alt))
  add(query_593982, "oauth_token", newJString(oauthToken))
  add(query_593982, "callback", newJString(callback))
  add(query_593982, "access_token", newJString(accessToken))
  add(query_593982, "uploadType", newJString(uploadType))
  add(query_593982, "key", newJString(key))
  add(query_593982, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593983 = body
  add(query_593982, "prettyPrint", newJBool(prettyPrint))
  result = call_593981.call(nil, query_593982, nil, nil, body_593983)

var jobsCompaniesCreate* = Call_JobsCompaniesCreate_593965(
    name: "jobsCompaniesCreate", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/companies",
    validator: validate_JobsCompaniesCreate_593966, base: "/",
    url: url_JobsCompaniesCreate_593967, schemes: {Scheme.Https})
type
  Call_JobsCompaniesList_593690 = ref object of OpenApiRestCall_593421
proc url_JobsCompaniesList_593692(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobsCompaniesList_593691(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists all companies associated with a Cloud Talent Solution account.
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
  ##            : Optional. The starting indicator from which to return results.
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
  ##   mustHaveOpenJobs: JBool
  ##                   : Optional. Set to true if the companies request must have open jobs.
  ## 
  ## Defaults to false.
  ## 
  ## If true, at most page_size of companies are fetched, among which
  ## only those with open jobs are returned.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of companies to be returned, at most 100.
  ## Default is 100 if a non-positive number is provided.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
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
  var valid_593806 = query.getOrDefault("pageToken")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "pageToken", valid_593806
  var valid_593807 = query.getOrDefault("quotaUser")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "quotaUser", valid_593807
  var valid_593821 = query.getOrDefault("alt")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = newJString("json"))
  if valid_593821 != nil:
    section.add "alt", valid_593821
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
  var valid_593826 = query.getOrDefault("mustHaveOpenJobs")
  valid_593826 = validateParameter(valid_593826, JBool, required = false, default = nil)
  if valid_593826 != nil:
    section.add "mustHaveOpenJobs", valid_593826
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
  var valid_593829 = query.getOrDefault("pageSize")
  valid_593829 = validateParameter(valid_593829, JInt, required = false, default = nil)
  if valid_593829 != nil:
    section.add "pageSize", valid_593829
  var valid_593830 = query.getOrDefault("prettyPrint")
  valid_593830 = validateParameter(valid_593830, JBool, required = false,
                                 default = newJBool(true))
  if valid_593830 != nil:
    section.add "prettyPrint", valid_593830
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593853: Call_JobsCompaniesList_593690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all companies associated with a Cloud Talent Solution account.
  ## 
  let valid = call_593853.validator(path, query, header, formData, body)
  let scheme = call_593853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593853.url(scheme.get, call_593853.host, call_593853.base,
                         call_593853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593853, url, valid)

proc call*(call_593924: Call_JobsCompaniesList_593690; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          mustHaveOpenJobs: bool = false; key: string = ""; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## jobsCompaniesList
  ## Lists all companies associated with a Cloud Talent Solution account.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. The starting indicator from which to return results.
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
  ##   mustHaveOpenJobs: bool
  ##                   : Optional. Set to true if the companies request must have open jobs.
  ## 
  ## Defaults to false.
  ## 
  ## If true, at most page_size of companies are fetched, among which
  ## only those with open jobs are returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of companies to be returned, at most 100.
  ## Default is 100 if a non-positive number is provided.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593925 = newJObject()
  add(query_593925, "upload_protocol", newJString(uploadProtocol))
  add(query_593925, "fields", newJString(fields))
  add(query_593925, "pageToken", newJString(pageToken))
  add(query_593925, "quotaUser", newJString(quotaUser))
  add(query_593925, "alt", newJString(alt))
  add(query_593925, "oauth_token", newJString(oauthToken))
  add(query_593925, "callback", newJString(callback))
  add(query_593925, "access_token", newJString(accessToken))
  add(query_593925, "uploadType", newJString(uploadType))
  add(query_593925, "mustHaveOpenJobs", newJBool(mustHaveOpenJobs))
  add(query_593925, "key", newJString(key))
  add(query_593925, "$.xgafv", newJString(Xgafv))
  add(query_593925, "pageSize", newJInt(pageSize))
  add(query_593925, "prettyPrint", newJBool(prettyPrint))
  result = call_593924.call(nil, query_593925, nil, nil, nil)

var jobsCompaniesList* = Call_JobsCompaniesList_593690(name: "jobsCompaniesList",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2/companies",
    validator: validate_JobsCompaniesList_593691, base: "/",
    url: url_JobsCompaniesList_593692, schemes: {Scheme.Https})
type
  Call_JobsJobsCreate_594005 = ref object of OpenApiRestCall_593421
proc url_JobsJobsCreate_594007(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobsJobsCreate_594006(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates a new job.
  ## 
  ## Typically, the job becomes searchable within 10 seconds, but it may take
  ## up to 5 minutes.
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
  var valid_594018 = query.getOrDefault("prettyPrint")
  valid_594018 = validateParameter(valid_594018, JBool, required = false,
                                 default = newJBool(true))
  if valid_594018 != nil:
    section.add "prettyPrint", valid_594018
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

proc call*(call_594020: Call_JobsJobsCreate_594005; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new job.
  ## 
  ## Typically, the job becomes searchable within 10 seconds, but it may take
  ## up to 5 minutes.
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_JobsJobsCreate_594005; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsJobsCreate
  ## Creates a new job.
  ## 
  ## Typically, the job becomes searchable within 10 seconds, but it may take
  ## up to 5 minutes.
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
  var query_594022 = newJObject()
  var body_594023 = newJObject()
  add(query_594022, "upload_protocol", newJString(uploadProtocol))
  add(query_594022, "fields", newJString(fields))
  add(query_594022, "quotaUser", newJString(quotaUser))
  add(query_594022, "alt", newJString(alt))
  add(query_594022, "oauth_token", newJString(oauthToken))
  add(query_594022, "callback", newJString(callback))
  add(query_594022, "access_token", newJString(accessToken))
  add(query_594022, "uploadType", newJString(uploadType))
  add(query_594022, "key", newJString(key))
  add(query_594022, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594023 = body
  add(query_594022, "prettyPrint", newJBool(prettyPrint))
  result = call_594021.call(nil, query_594022, nil, nil, body_594023)

var jobsJobsCreate* = Call_JobsJobsCreate_594005(name: "jobsJobsCreate",
    meth: HttpMethod.HttpPost, host: "jobs.googleapis.com", route: "/v2/jobs",
    validator: validate_JobsJobsCreate_594006, base: "/", url: url_JobsJobsCreate_594007,
    schemes: {Scheme.Https})
type
  Call_JobsJobsList_593984 = ref object of OpenApiRestCall_593421
proc url_JobsJobsList_593986(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobsJobsList_593985(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists jobs by filter.
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
  ##            : Optional. The starting point of a query result.
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
  ##   idsOnly: JBool
  ##          : Optional. If set to `true`, only Job.name, Job.requisition_id and
  ## Job.language_code will be returned.
  ## 
  ## A typical use case is to synchronize job repositories.
  ## 
  ## Defaults to false.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of jobs to be returned per page of results.
  ## 
  ## If ids_only is set to true, the maximum allowed page size
  ## is 1000. Otherwise, the maximum allowed page size is 100.
  ## 
  ## Default is 100 if empty or a number < 1 is specified.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Required. The filter string specifies the jobs to be enumerated.
  ## 
  ## Supported operator: =, AND
  ## 
  ## The fields eligible for filtering are:
  ## 
  ## * `companyName` (Required)
  ## * `requisitionId` (Optional)
  ## 
  ## Sample Query:
  ## 
  ## * companyName = "companies/123"
  ## * companyName = "companies/123" AND requisitionId = "req-1"
  section = newJObject()
  var valid_593987 = query.getOrDefault("upload_protocol")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "upload_protocol", valid_593987
  var valid_593988 = query.getOrDefault("fields")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "fields", valid_593988
  var valid_593989 = query.getOrDefault("pageToken")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "pageToken", valid_593989
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
  var valid_593996 = query.getOrDefault("idsOnly")
  valid_593996 = validateParameter(valid_593996, JBool, required = false, default = nil)
  if valid_593996 != nil:
    section.add "idsOnly", valid_593996
  var valid_593997 = query.getOrDefault("key")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "key", valid_593997
  var valid_593998 = query.getOrDefault("$.xgafv")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = newJString("1"))
  if valid_593998 != nil:
    section.add "$.xgafv", valid_593998
  var valid_593999 = query.getOrDefault("pageSize")
  valid_593999 = validateParameter(valid_593999, JInt, required = false, default = nil)
  if valid_593999 != nil:
    section.add "pageSize", valid_593999
  var valid_594000 = query.getOrDefault("prettyPrint")
  valid_594000 = validateParameter(valid_594000, JBool, required = false,
                                 default = newJBool(true))
  if valid_594000 != nil:
    section.add "prettyPrint", valid_594000
  var valid_594001 = query.getOrDefault("filter")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "filter", valid_594001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594002: Call_JobsJobsList_593984; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists jobs by filter.
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_JobsJobsList_593984; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; idsOnly: bool = false;
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## jobsJobsList
  ## Lists jobs by filter.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. The starting point of a query result.
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
  ##   idsOnly: bool
  ##          : Optional. If set to `true`, only Job.name, Job.requisition_id and
  ## Job.language_code will be returned.
  ## 
  ## A typical use case is to synchronize job repositories.
  ## 
  ## Defaults to false.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of jobs to be returned per page of results.
  ## 
  ## If ids_only is set to true, the maximum allowed page size
  ## is 1000. Otherwise, the maximum allowed page size is 100.
  ## 
  ## Default is 100 if empty or a number < 1 is specified.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Required. The filter string specifies the jobs to be enumerated.
  ## 
  ## Supported operator: =, AND
  ## 
  ## The fields eligible for filtering are:
  ## 
  ## * `companyName` (Required)
  ## * `requisitionId` (Optional)
  ## 
  ## Sample Query:
  ## 
  ## * companyName = "companies/123"
  ## * companyName = "companies/123" AND requisitionId = "req-1"
  var query_594004 = newJObject()
  add(query_594004, "upload_protocol", newJString(uploadProtocol))
  add(query_594004, "fields", newJString(fields))
  add(query_594004, "pageToken", newJString(pageToken))
  add(query_594004, "quotaUser", newJString(quotaUser))
  add(query_594004, "alt", newJString(alt))
  add(query_594004, "oauth_token", newJString(oauthToken))
  add(query_594004, "callback", newJString(callback))
  add(query_594004, "access_token", newJString(accessToken))
  add(query_594004, "uploadType", newJString(uploadType))
  add(query_594004, "idsOnly", newJBool(idsOnly))
  add(query_594004, "key", newJString(key))
  add(query_594004, "$.xgafv", newJString(Xgafv))
  add(query_594004, "pageSize", newJInt(pageSize))
  add(query_594004, "prettyPrint", newJBool(prettyPrint))
  add(query_594004, "filter", newJString(filter))
  result = call_594003.call(nil, query_594004, nil, nil, nil)

var jobsJobsList* = Call_JobsJobsList_593984(name: "jobsJobsList",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2/jobs",
    validator: validate_JobsJobsList_593985, base: "/", url: url_JobsJobsList_593986,
    schemes: {Scheme.Https})
type
  Call_JobsJobsBatchDelete_594024 = ref object of OpenApiRestCall_593421
proc url_JobsJobsBatchDelete_594026(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobsJobsBatchDelete_594025(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a list of Job postings by filter.
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
  var valid_594027 = query.getOrDefault("upload_protocol")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "upload_protocol", valid_594027
  var valid_594028 = query.getOrDefault("fields")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "fields", valid_594028
  var valid_594029 = query.getOrDefault("quotaUser")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "quotaUser", valid_594029
  var valid_594030 = query.getOrDefault("alt")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = newJString("json"))
  if valid_594030 != nil:
    section.add "alt", valid_594030
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

proc call*(call_594039: Call_JobsJobsBatchDelete_594024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a list of Job postings by filter.
  ## 
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_JobsJobsBatchDelete_594024;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsJobsBatchDelete
  ## Deletes a list of Job postings by filter.
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
  var query_594041 = newJObject()
  var body_594042 = newJObject()
  add(query_594041, "upload_protocol", newJString(uploadProtocol))
  add(query_594041, "fields", newJString(fields))
  add(query_594041, "quotaUser", newJString(quotaUser))
  add(query_594041, "alt", newJString(alt))
  add(query_594041, "oauth_token", newJString(oauthToken))
  add(query_594041, "callback", newJString(callback))
  add(query_594041, "access_token", newJString(accessToken))
  add(query_594041, "uploadType", newJString(uploadType))
  add(query_594041, "key", newJString(key))
  add(query_594041, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594042 = body
  add(query_594041, "prettyPrint", newJBool(prettyPrint))
  result = call_594040.call(nil, query_594041, nil, nil, body_594042)

var jobsJobsBatchDelete* = Call_JobsJobsBatchDelete_594024(
    name: "jobsJobsBatchDelete", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/jobs:batchDelete",
    validator: validate_JobsJobsBatchDelete_594025, base: "/",
    url: url_JobsJobsBatchDelete_594026, schemes: {Scheme.Https})
type
  Call_JobsJobsDeleteByFilter_594043 = ref object of OpenApiRestCall_593421
proc url_JobsJobsDeleteByFilter_594045(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobsJobsDeleteByFilter_594044(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deprecated. Use BatchDeleteJobs instead.
  ## 
  ## Deletes the specified job by filter. You can specify whether to
  ## synchronously wait for validation, indexing, and general processing to be
  ## completed before the response is returned.
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
  var valid_594046 = query.getOrDefault("upload_protocol")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "upload_protocol", valid_594046
  var valid_594047 = query.getOrDefault("fields")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "fields", valid_594047
  var valid_594048 = query.getOrDefault("quotaUser")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "quotaUser", valid_594048
  var valid_594049 = query.getOrDefault("alt")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = newJString("json"))
  if valid_594049 != nil:
    section.add "alt", valid_594049
  var valid_594050 = query.getOrDefault("oauth_token")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "oauth_token", valid_594050
  var valid_594051 = query.getOrDefault("callback")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "callback", valid_594051
  var valid_594052 = query.getOrDefault("access_token")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "access_token", valid_594052
  var valid_594053 = query.getOrDefault("uploadType")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "uploadType", valid_594053
  var valid_594054 = query.getOrDefault("key")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "key", valid_594054
  var valid_594055 = query.getOrDefault("$.xgafv")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = newJString("1"))
  if valid_594055 != nil:
    section.add "$.xgafv", valid_594055
  var valid_594056 = query.getOrDefault("prettyPrint")
  valid_594056 = validateParameter(valid_594056, JBool, required = false,
                                 default = newJBool(true))
  if valid_594056 != nil:
    section.add "prettyPrint", valid_594056
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

proc call*(call_594058: Call_JobsJobsDeleteByFilter_594043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated. Use BatchDeleteJobs instead.
  ## 
  ## Deletes the specified job by filter. You can specify whether to
  ## synchronously wait for validation, indexing, and general processing to be
  ## completed before the response is returned.
  ## 
  let valid = call_594058.validator(path, query, header, formData, body)
  let scheme = call_594058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594058.url(scheme.get, call_594058.host, call_594058.base,
                         call_594058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594058, url, valid)

proc call*(call_594059: Call_JobsJobsDeleteByFilter_594043;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsJobsDeleteByFilter
  ## Deprecated. Use BatchDeleteJobs instead.
  ## 
  ## Deletes the specified job by filter. You can specify whether to
  ## synchronously wait for validation, indexing, and general processing to be
  ## completed before the response is returned.
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
  var query_594060 = newJObject()
  var body_594061 = newJObject()
  add(query_594060, "upload_protocol", newJString(uploadProtocol))
  add(query_594060, "fields", newJString(fields))
  add(query_594060, "quotaUser", newJString(quotaUser))
  add(query_594060, "alt", newJString(alt))
  add(query_594060, "oauth_token", newJString(oauthToken))
  add(query_594060, "callback", newJString(callback))
  add(query_594060, "access_token", newJString(accessToken))
  add(query_594060, "uploadType", newJString(uploadType))
  add(query_594060, "key", newJString(key))
  add(query_594060, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594061 = body
  add(query_594060, "prettyPrint", newJBool(prettyPrint))
  result = call_594059.call(nil, query_594060, nil, nil, body_594061)

var jobsJobsDeleteByFilter* = Call_JobsJobsDeleteByFilter_594043(
    name: "jobsJobsDeleteByFilter", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/jobs:deleteByFilter",
    validator: validate_JobsJobsDeleteByFilter_594044, base: "/",
    url: url_JobsJobsDeleteByFilter_594045, schemes: {Scheme.Https})
type
  Call_JobsJobsHistogram_594062 = ref object of OpenApiRestCall_593421
proc url_JobsJobsHistogram_594064(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobsJobsHistogram_594063(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deprecated. Use SearchJobsRequest.histogram_facets instead to make
  ## a single call with both search and histogram.
  ## 
  ## Retrieves a histogram for the given
  ## GetHistogramRequest. This call provides a structured
  ## count of jobs that match against the search query, grouped by specified
  ## facets.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only counts jobs the caller has
  ## permission to search against.
  ## 
  ## For example, use this call to generate the
  ## number of jobs in the U.S. by state.
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
  var valid_594065 = query.getOrDefault("upload_protocol")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "upload_protocol", valid_594065
  var valid_594066 = query.getOrDefault("fields")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "fields", valid_594066
  var valid_594067 = query.getOrDefault("quotaUser")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "quotaUser", valid_594067
  var valid_594068 = query.getOrDefault("alt")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = newJString("json"))
  if valid_594068 != nil:
    section.add "alt", valid_594068
  var valid_594069 = query.getOrDefault("oauth_token")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "oauth_token", valid_594069
  var valid_594070 = query.getOrDefault("callback")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "callback", valid_594070
  var valid_594071 = query.getOrDefault("access_token")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "access_token", valid_594071
  var valid_594072 = query.getOrDefault("uploadType")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "uploadType", valid_594072
  var valid_594073 = query.getOrDefault("key")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "key", valid_594073
  var valid_594074 = query.getOrDefault("$.xgafv")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = newJString("1"))
  if valid_594074 != nil:
    section.add "$.xgafv", valid_594074
  var valid_594075 = query.getOrDefault("prettyPrint")
  valid_594075 = validateParameter(valid_594075, JBool, required = false,
                                 default = newJBool(true))
  if valid_594075 != nil:
    section.add "prettyPrint", valid_594075
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

proc call*(call_594077: Call_JobsJobsHistogram_594062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated. Use SearchJobsRequest.histogram_facets instead to make
  ## a single call with both search and histogram.
  ## 
  ## Retrieves a histogram for the given
  ## GetHistogramRequest. This call provides a structured
  ## count of jobs that match against the search query, grouped by specified
  ## facets.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only counts jobs the caller has
  ## permission to search against.
  ## 
  ## For example, use this call to generate the
  ## number of jobs in the U.S. by state.
  ## 
  let valid = call_594077.validator(path, query, header, formData, body)
  let scheme = call_594077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594077.url(scheme.get, call_594077.host, call_594077.base,
                         call_594077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594077, url, valid)

proc call*(call_594078: Call_JobsJobsHistogram_594062; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsJobsHistogram
  ## Deprecated. Use SearchJobsRequest.histogram_facets instead to make
  ## a single call with both search and histogram.
  ## 
  ## Retrieves a histogram for the given
  ## GetHistogramRequest. This call provides a structured
  ## count of jobs that match against the search query, grouped by specified
  ## facets.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only counts jobs the caller has
  ## permission to search against.
  ## 
  ## For example, use this call to generate the
  ## number of jobs in the U.S. by state.
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
  var query_594079 = newJObject()
  var body_594080 = newJObject()
  add(query_594079, "upload_protocol", newJString(uploadProtocol))
  add(query_594079, "fields", newJString(fields))
  add(query_594079, "quotaUser", newJString(quotaUser))
  add(query_594079, "alt", newJString(alt))
  add(query_594079, "oauth_token", newJString(oauthToken))
  add(query_594079, "callback", newJString(callback))
  add(query_594079, "access_token", newJString(accessToken))
  add(query_594079, "uploadType", newJString(uploadType))
  add(query_594079, "key", newJString(key))
  add(query_594079, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594080 = body
  add(query_594079, "prettyPrint", newJBool(prettyPrint))
  result = call_594078.call(nil, query_594079, nil, nil, body_594080)

var jobsJobsHistogram* = Call_JobsJobsHistogram_594062(name: "jobsJobsHistogram",
    meth: HttpMethod.HttpPost, host: "jobs.googleapis.com",
    route: "/v2/jobs:histogram", validator: validate_JobsJobsHistogram_594063,
    base: "/", url: url_JobsJobsHistogram_594064, schemes: {Scheme.Https})
type
  Call_JobsJobsSearch_594081 = ref object of OpenApiRestCall_593421
proc url_JobsJobsSearch_594083(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobsJobsSearch_594082(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs that the caller has
  ## permission to search against.
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

proc call*(call_594096: Call_JobsJobsSearch_594081; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs that the caller has
  ## permission to search against.
  ## 
  let valid = call_594096.validator(path, query, header, formData, body)
  let scheme = call_594096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594096.url(scheme.get, call_594096.host, call_594096.base,
                         call_594096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594096, url, valid)

proc call*(call_594097: Call_JobsJobsSearch_594081; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsJobsSearch
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs that the caller has
  ## permission to search against.
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
  var query_594098 = newJObject()
  var body_594099 = newJObject()
  add(query_594098, "upload_protocol", newJString(uploadProtocol))
  add(query_594098, "fields", newJString(fields))
  add(query_594098, "quotaUser", newJString(quotaUser))
  add(query_594098, "alt", newJString(alt))
  add(query_594098, "oauth_token", newJString(oauthToken))
  add(query_594098, "callback", newJString(callback))
  add(query_594098, "access_token", newJString(accessToken))
  add(query_594098, "uploadType", newJString(uploadType))
  add(query_594098, "key", newJString(key))
  add(query_594098, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594099 = body
  add(query_594098, "prettyPrint", newJBool(prettyPrint))
  result = call_594097.call(nil, query_594098, nil, nil, body_594099)

var jobsJobsSearch* = Call_JobsJobsSearch_594081(name: "jobsJobsSearch",
    meth: HttpMethod.HttpPost, host: "jobs.googleapis.com",
    route: "/v2/jobs:search", validator: validate_JobsJobsSearch_594082, base: "/",
    url: url_JobsJobsSearch_594083, schemes: {Scheme.Https})
type
  Call_JobsJobsSearchForAlert_594100 = ref object of OpenApiRestCall_593421
proc url_JobsJobsSearchForAlert_594102(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobsJobsSearchForAlert_594101(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This API call is intended for the use case of targeting passive job
  ## seekers (for example, job seekers who have signed up to receive email
  ## alerts about potential job opportunities), and has different algorithmic
  ## adjustments that are targeted to passive job seekers.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs the caller has
  ## permission to search against.
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
  var valid_594103 = query.getOrDefault("upload_protocol")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "upload_protocol", valid_594103
  var valid_594104 = query.getOrDefault("fields")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "fields", valid_594104
  var valid_594105 = query.getOrDefault("quotaUser")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "quotaUser", valid_594105
  var valid_594106 = query.getOrDefault("alt")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = newJString("json"))
  if valid_594106 != nil:
    section.add "alt", valid_594106
  var valid_594107 = query.getOrDefault("oauth_token")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "oauth_token", valid_594107
  var valid_594108 = query.getOrDefault("callback")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "callback", valid_594108
  var valid_594109 = query.getOrDefault("access_token")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "access_token", valid_594109
  var valid_594110 = query.getOrDefault("uploadType")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "uploadType", valid_594110
  var valid_594111 = query.getOrDefault("key")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "key", valid_594111
  var valid_594112 = query.getOrDefault("$.xgafv")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = newJString("1"))
  if valid_594112 != nil:
    section.add "$.xgafv", valid_594112
  var valid_594113 = query.getOrDefault("prettyPrint")
  valid_594113 = validateParameter(valid_594113, JBool, required = false,
                                 default = newJBool(true))
  if valid_594113 != nil:
    section.add "prettyPrint", valid_594113
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

proc call*(call_594115: Call_JobsJobsSearchForAlert_594100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This API call is intended for the use case of targeting passive job
  ## seekers (for example, job seekers who have signed up to receive email
  ## alerts about potential job opportunities), and has different algorithmic
  ## adjustments that are targeted to passive job seekers.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs the caller has
  ## permission to search against.
  ## 
  let valid = call_594115.validator(path, query, header, formData, body)
  let scheme = call_594115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594115.url(scheme.get, call_594115.host, call_594115.base,
                         call_594115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594115, url, valid)

proc call*(call_594116: Call_JobsJobsSearchForAlert_594100;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsJobsSearchForAlert
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This API call is intended for the use case of targeting passive job
  ## seekers (for example, job seekers who have signed up to receive email
  ## alerts about potential job opportunities), and has different algorithmic
  ## adjustments that are targeted to passive job seekers.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs the caller has
  ## permission to search against.
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
  var query_594117 = newJObject()
  var body_594118 = newJObject()
  add(query_594117, "upload_protocol", newJString(uploadProtocol))
  add(query_594117, "fields", newJString(fields))
  add(query_594117, "quotaUser", newJString(quotaUser))
  add(query_594117, "alt", newJString(alt))
  add(query_594117, "oauth_token", newJString(oauthToken))
  add(query_594117, "callback", newJString(callback))
  add(query_594117, "access_token", newJString(accessToken))
  add(query_594117, "uploadType", newJString(uploadType))
  add(query_594117, "key", newJString(key))
  add(query_594117, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594118 = body
  add(query_594117, "prettyPrint", newJBool(prettyPrint))
  result = call_594116.call(nil, query_594117, nil, nil, body_594118)

var jobsJobsSearchForAlert* = Call_JobsJobsSearchForAlert_594100(
    name: "jobsJobsSearchForAlert", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/jobs:searchForAlert",
    validator: validate_JobsJobsSearchForAlert_594101, base: "/",
    url: url_JobsJobsSearchForAlert_594102, schemes: {Scheme.Https})
type
  Call_JobsCompaniesJobsList_594119 = ref object of OpenApiRestCall_593421
proc url_JobsCompaniesJobsList_594121(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "companyName" in path, "`companyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "companyName"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsCompaniesJobsList_594120(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deprecated. Use ListJobs instead.
  ## 
  ## Lists all jobs associated with a company.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   companyName: JString (required)
  ##              : Required. The resource name of the company that owns the jobs to be listed,
  ## such as, "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `companyName` field"
  var valid_594136 = path.getOrDefault("companyName")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "companyName", valid_594136
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. The starting point of a query result.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   jobRequisitionId: JString
  ##                   : Optional. The requisition ID, also known as posting ID, assigned by the company
  ## to the job.
  ## 
  ## The maximum number of allowable characters is 225.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   idsOnly: JBool
  ##          : Optional. If set to `true`, only job ID, job requisition ID and language code will be
  ## returned.
  ## 
  ## A typical use is to synchronize job repositories.
  ## 
  ## Defaults to false.
  ##   includeJobsCount: JBool
  ##                   : Deprecated. Please DO NOT use this field except for small companies.
  ## Suggest counting jobs page by page instead.
  ## 
  ## Optional.
  ## 
  ## Set to true if the total number of open jobs is to be returned.
  ## 
  ## Defaults to false.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of jobs to be returned per page of results.
  ## 
  ## If ids_only is set to true, the maximum allowed page size
  ## is 1000. Otherwise, the maximum allowed page size is 100.
  ## 
  ## Default is 100 if empty or a number < 1 is specified.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594137 = query.getOrDefault("upload_protocol")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "upload_protocol", valid_594137
  var valid_594138 = query.getOrDefault("fields")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = nil)
  if valid_594138 != nil:
    section.add "fields", valid_594138
  var valid_594139 = query.getOrDefault("pageToken")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "pageToken", valid_594139
  var valid_594140 = query.getOrDefault("quotaUser")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "quotaUser", valid_594140
  var valid_594141 = query.getOrDefault("alt")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = newJString("json"))
  if valid_594141 != nil:
    section.add "alt", valid_594141
  var valid_594142 = query.getOrDefault("jobRequisitionId")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "jobRequisitionId", valid_594142
  var valid_594143 = query.getOrDefault("oauth_token")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "oauth_token", valid_594143
  var valid_594144 = query.getOrDefault("callback")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "callback", valid_594144
  var valid_594145 = query.getOrDefault("access_token")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "access_token", valid_594145
  var valid_594146 = query.getOrDefault("uploadType")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "uploadType", valid_594146
  var valid_594147 = query.getOrDefault("idsOnly")
  valid_594147 = validateParameter(valid_594147, JBool, required = false, default = nil)
  if valid_594147 != nil:
    section.add "idsOnly", valid_594147
  var valid_594148 = query.getOrDefault("includeJobsCount")
  valid_594148 = validateParameter(valid_594148, JBool, required = false, default = nil)
  if valid_594148 != nil:
    section.add "includeJobsCount", valid_594148
  var valid_594149 = query.getOrDefault("key")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "key", valid_594149
  var valid_594150 = query.getOrDefault("$.xgafv")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = newJString("1"))
  if valid_594150 != nil:
    section.add "$.xgafv", valid_594150
  var valid_594151 = query.getOrDefault("pageSize")
  valid_594151 = validateParameter(valid_594151, JInt, required = false, default = nil)
  if valid_594151 != nil:
    section.add "pageSize", valid_594151
  var valid_594152 = query.getOrDefault("prettyPrint")
  valid_594152 = validateParameter(valid_594152, JBool, required = false,
                                 default = newJBool(true))
  if valid_594152 != nil:
    section.add "prettyPrint", valid_594152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594153: Call_JobsCompaniesJobsList_594119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated. Use ListJobs instead.
  ## 
  ## Lists all jobs associated with a company.
  ## 
  let valid = call_594153.validator(path, query, header, formData, body)
  let scheme = call_594153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594153.url(scheme.get, call_594153.host, call_594153.base,
                         call_594153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594153, url, valid)

proc call*(call_594154: Call_JobsCompaniesJobsList_594119; companyName: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; jobRequisitionId: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; idsOnly: bool = false;
          includeJobsCount: bool = false; key: string = ""; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## jobsCompaniesJobsList
  ## Deprecated. Use ListJobs instead.
  ## 
  ## Lists all jobs associated with a company.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. The starting point of a query result.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobRequisitionId: string
  ##                   : Optional. The requisition ID, also known as posting ID, assigned by the company
  ## to the job.
  ## 
  ## The maximum number of allowable characters is 225.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   idsOnly: bool
  ##          : Optional. If set to `true`, only job ID, job requisition ID and language code will be
  ## returned.
  ## 
  ## A typical use is to synchronize job repositories.
  ## 
  ## Defaults to false.
  ##   includeJobsCount: bool
  ##                   : Deprecated. Please DO NOT use this field except for small companies.
  ## Suggest counting jobs page by page instead.
  ## 
  ## Optional.
  ## 
  ## Set to true if the total number of open jobs is to be returned.
  ## 
  ## Defaults to false.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of jobs to be returned per page of results.
  ## 
  ## If ids_only is set to true, the maximum allowed page size
  ## is 1000. Otherwise, the maximum allowed page size is 100.
  ## 
  ## Default is 100 if empty or a number < 1 is specified.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   companyName: string (required)
  ##              : Required. The resource name of the company that owns the jobs to be listed,
  ## such as, "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
  var path_594155 = newJObject()
  var query_594156 = newJObject()
  add(query_594156, "upload_protocol", newJString(uploadProtocol))
  add(query_594156, "fields", newJString(fields))
  add(query_594156, "pageToken", newJString(pageToken))
  add(query_594156, "quotaUser", newJString(quotaUser))
  add(query_594156, "alt", newJString(alt))
  add(query_594156, "jobRequisitionId", newJString(jobRequisitionId))
  add(query_594156, "oauth_token", newJString(oauthToken))
  add(query_594156, "callback", newJString(callback))
  add(query_594156, "access_token", newJString(accessToken))
  add(query_594156, "uploadType", newJString(uploadType))
  add(query_594156, "idsOnly", newJBool(idsOnly))
  add(query_594156, "includeJobsCount", newJBool(includeJobsCount))
  add(query_594156, "key", newJString(key))
  add(query_594156, "$.xgafv", newJString(Xgafv))
  add(query_594156, "pageSize", newJInt(pageSize))
  add(query_594156, "prettyPrint", newJBool(prettyPrint))
  add(path_594155, "companyName", newJString(companyName))
  result = call_594154.call(path_594155, query_594156, nil, nil, nil)

var jobsCompaniesJobsList* = Call_JobsCompaniesJobsList_594119(
    name: "jobsCompaniesJobsList", meth: HttpMethod.HttpGet,
    host: "jobs.googleapis.com", route: "/v2/{companyName}/jobs",
    validator: validate_JobsCompaniesJobsList_594120, base: "/",
    url: url_JobsCompaniesJobsList_594121, schemes: {Scheme.Https})
type
  Call_JobsCompaniesGet_594157 = ref object of OpenApiRestCall_593421
proc url_JobsCompaniesGet_594159(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_JobsCompaniesGet_594158(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves the specified company.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Resource name of the company to retrieve,
  ## such as "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594160 = path.getOrDefault("name")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "name", valid_594160
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
  var valid_594161 = query.getOrDefault("upload_protocol")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "upload_protocol", valid_594161
  var valid_594162 = query.getOrDefault("fields")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "fields", valid_594162
  var valid_594163 = query.getOrDefault("quotaUser")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "quotaUser", valid_594163
  var valid_594164 = query.getOrDefault("alt")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = newJString("json"))
  if valid_594164 != nil:
    section.add "alt", valid_594164
  var valid_594165 = query.getOrDefault("oauth_token")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "oauth_token", valid_594165
  var valid_594166 = query.getOrDefault("callback")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "callback", valid_594166
  var valid_594167 = query.getOrDefault("access_token")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "access_token", valid_594167
  var valid_594168 = query.getOrDefault("uploadType")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "uploadType", valid_594168
  var valid_594169 = query.getOrDefault("key")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "key", valid_594169
  var valid_594170 = query.getOrDefault("$.xgafv")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = newJString("1"))
  if valid_594170 != nil:
    section.add "$.xgafv", valid_594170
  var valid_594171 = query.getOrDefault("prettyPrint")
  valid_594171 = validateParameter(valid_594171, JBool, required = false,
                                 default = newJBool(true))
  if valid_594171 != nil:
    section.add "prettyPrint", valid_594171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594172: Call_JobsCompaniesGet_594157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified company.
  ## 
  let valid = call_594172.validator(path, query, header, formData, body)
  let scheme = call_594172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594172.url(scheme.get, call_594172.host, call_594172.base,
                         call_594172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594172, url, valid)

proc call*(call_594173: Call_JobsCompaniesGet_594157; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## jobsCompaniesGet
  ## Retrieves the specified company.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Resource name of the company to retrieve,
  ## such as "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
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
  var path_594174 = newJObject()
  var query_594175 = newJObject()
  add(query_594175, "upload_protocol", newJString(uploadProtocol))
  add(query_594175, "fields", newJString(fields))
  add(query_594175, "quotaUser", newJString(quotaUser))
  add(path_594174, "name", newJString(name))
  add(query_594175, "alt", newJString(alt))
  add(query_594175, "oauth_token", newJString(oauthToken))
  add(query_594175, "callback", newJString(callback))
  add(query_594175, "access_token", newJString(accessToken))
  add(query_594175, "uploadType", newJString(uploadType))
  add(query_594175, "key", newJString(key))
  add(query_594175, "$.xgafv", newJString(Xgafv))
  add(query_594175, "prettyPrint", newJBool(prettyPrint))
  result = call_594173.call(path_594174, query_594175, nil, nil, nil)

var jobsCompaniesGet* = Call_JobsCompaniesGet_594157(name: "jobsCompaniesGet",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2/{name}",
    validator: validate_JobsCompaniesGet_594158, base: "/",
    url: url_JobsCompaniesGet_594159, schemes: {Scheme.Https})
type
  Call_JobsCompaniesPatch_594196 = ref object of OpenApiRestCall_593421
proc url_JobsCompaniesPatch_594198(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_JobsCompaniesPatch_594197(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the specified company. Company names can't be updated. To update a
  ## company name, delete the company and all jobs associated with it, and only
  ## then re-create them.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required during company update.
  ## 
  ## The resource name for a company. This is generated by the service when a
  ## company is created, for example,
  ## "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594199 = path.getOrDefault("name")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "name", valid_594199
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
  ##   updateCompanyFields: JString
  ##                      : Optional but strongly recommended to be provided for the best service
  ## experience.
  ## 
  ## If update_company_fields is provided, only the specified fields in
  ## company are updated. Otherwise all the fields are updated.
  ## 
  ## A field mask to specify the company fields to update. Valid values are:
  ## 
  ## * displayName
  ## * website
  ## * imageUrl
  ## * companySize
  ## * distributorBillingCompanyId
  ## * companyInfoSources
  ## * careerPageLink
  ## * hiringAgency
  ## * hqLocation
  ## * eeoText
  ## * keywordSearchableCustomAttributes
  ## * title (deprecated)
  ## * keywordSearchableCustomFields (deprecated)
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594200 = query.getOrDefault("upload_protocol")
  valid_594200 = validateParameter(valid_594200, JString, required = false,
                                 default = nil)
  if valid_594200 != nil:
    section.add "upload_protocol", valid_594200
  var valid_594201 = query.getOrDefault("fields")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "fields", valid_594201
  var valid_594202 = query.getOrDefault("quotaUser")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = nil)
  if valid_594202 != nil:
    section.add "quotaUser", valid_594202
  var valid_594203 = query.getOrDefault("alt")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = newJString("json"))
  if valid_594203 != nil:
    section.add "alt", valid_594203
  var valid_594204 = query.getOrDefault("oauth_token")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "oauth_token", valid_594204
  var valid_594205 = query.getOrDefault("callback")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "callback", valid_594205
  var valid_594206 = query.getOrDefault("access_token")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = nil)
  if valid_594206 != nil:
    section.add "access_token", valid_594206
  var valid_594207 = query.getOrDefault("uploadType")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = nil)
  if valid_594207 != nil:
    section.add "uploadType", valid_594207
  var valid_594208 = query.getOrDefault("updateCompanyFields")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "updateCompanyFields", valid_594208
  var valid_594209 = query.getOrDefault("key")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "key", valid_594209
  var valid_594210 = query.getOrDefault("$.xgafv")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = newJString("1"))
  if valid_594210 != nil:
    section.add "$.xgafv", valid_594210
  var valid_594211 = query.getOrDefault("prettyPrint")
  valid_594211 = validateParameter(valid_594211, JBool, required = false,
                                 default = newJBool(true))
  if valid_594211 != nil:
    section.add "prettyPrint", valid_594211
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

proc call*(call_594213: Call_JobsCompaniesPatch_594196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified company. Company names can't be updated. To update a
  ## company name, delete the company and all jobs associated with it, and only
  ## then re-create them.
  ## 
  let valid = call_594213.validator(path, query, header, formData, body)
  let scheme = call_594213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594213.url(scheme.get, call_594213.host, call_594213.base,
                         call_594213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594213, url, valid)

proc call*(call_594214: Call_JobsCompaniesPatch_594196; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          updateCompanyFields: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsCompaniesPatch
  ## Updates the specified company. Company names can't be updated. To update a
  ## company name, delete the company and all jobs associated with it, and only
  ## then re-create them.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required during company update.
  ## 
  ## The resource name for a company. This is generated by the service when a
  ## company is created, for example,
  ## "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
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
  ##   updateCompanyFields: string
  ##                      : Optional but strongly recommended to be provided for the best service
  ## experience.
  ## 
  ## If update_company_fields is provided, only the specified fields in
  ## company are updated. Otherwise all the fields are updated.
  ## 
  ## A field mask to specify the company fields to update. Valid values are:
  ## 
  ## * displayName
  ## * website
  ## * imageUrl
  ## * companySize
  ## * distributorBillingCompanyId
  ## * companyInfoSources
  ## * careerPageLink
  ## * hiringAgency
  ## * hqLocation
  ## * eeoText
  ## * keywordSearchableCustomAttributes
  ## * title (deprecated)
  ## * keywordSearchableCustomFields (deprecated)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594215 = newJObject()
  var query_594216 = newJObject()
  var body_594217 = newJObject()
  add(query_594216, "upload_protocol", newJString(uploadProtocol))
  add(query_594216, "fields", newJString(fields))
  add(query_594216, "quotaUser", newJString(quotaUser))
  add(path_594215, "name", newJString(name))
  add(query_594216, "alt", newJString(alt))
  add(query_594216, "oauth_token", newJString(oauthToken))
  add(query_594216, "callback", newJString(callback))
  add(query_594216, "access_token", newJString(accessToken))
  add(query_594216, "uploadType", newJString(uploadType))
  add(query_594216, "updateCompanyFields", newJString(updateCompanyFields))
  add(query_594216, "key", newJString(key))
  add(query_594216, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594217 = body
  add(query_594216, "prettyPrint", newJBool(prettyPrint))
  result = call_594214.call(path_594215, query_594216, nil, nil, body_594217)

var jobsCompaniesPatch* = Call_JobsCompaniesPatch_594196(
    name: "jobsCompaniesPatch", meth: HttpMethod.HttpPatch,
    host: "jobs.googleapis.com", route: "/v2/{name}",
    validator: validate_JobsCompaniesPatch_594197, base: "/",
    url: url_JobsCompaniesPatch_594198, schemes: {Scheme.Https})
type
  Call_JobsCompaniesDelete_594176 = ref object of OpenApiRestCall_593421
proc url_JobsCompaniesDelete_594178(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_JobsCompaniesDelete_594177(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified company.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the company to be deleted,
  ## such as, "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594179 = path.getOrDefault("name")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "name", valid_594179
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
  ##   disableFastProcess: JBool
  ##                     : Deprecated. This field is not working anymore.
  ## 
  ## Optional.
  ## 
  ## If set to true, this call waits for all processing steps to complete
  ## before the job is cleaned up. Otherwise, the call returns while some
  ## steps are still taking place asynchronously, hence faster.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594180 = query.getOrDefault("upload_protocol")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = nil)
  if valid_594180 != nil:
    section.add "upload_protocol", valid_594180
  var valid_594181 = query.getOrDefault("fields")
  valid_594181 = validateParameter(valid_594181, JString, required = false,
                                 default = nil)
  if valid_594181 != nil:
    section.add "fields", valid_594181
  var valid_594182 = query.getOrDefault("quotaUser")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = nil)
  if valid_594182 != nil:
    section.add "quotaUser", valid_594182
  var valid_594183 = query.getOrDefault("alt")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = newJString("json"))
  if valid_594183 != nil:
    section.add "alt", valid_594183
  var valid_594184 = query.getOrDefault("oauth_token")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "oauth_token", valid_594184
  var valid_594185 = query.getOrDefault("callback")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "callback", valid_594185
  var valid_594186 = query.getOrDefault("access_token")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "access_token", valid_594186
  var valid_594187 = query.getOrDefault("uploadType")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "uploadType", valid_594187
  var valid_594188 = query.getOrDefault("key")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "key", valid_594188
  var valid_594189 = query.getOrDefault("$.xgafv")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = newJString("1"))
  if valid_594189 != nil:
    section.add "$.xgafv", valid_594189
  var valid_594190 = query.getOrDefault("disableFastProcess")
  valid_594190 = validateParameter(valid_594190, JBool, required = false, default = nil)
  if valid_594190 != nil:
    section.add "disableFastProcess", valid_594190
  var valid_594191 = query.getOrDefault("prettyPrint")
  valid_594191 = validateParameter(valid_594191, JBool, required = false,
                                 default = newJBool(true))
  if valid_594191 != nil:
    section.add "prettyPrint", valid_594191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594192: Call_JobsCompaniesDelete_594176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified company.
  ## 
  let valid = call_594192.validator(path, query, header, formData, body)
  let scheme = call_594192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594192.url(scheme.get, call_594192.host, call_594192.base,
                         call_594192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594192, url, valid)

proc call*(call_594193: Call_JobsCompaniesDelete_594176; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; disableFastProcess: bool = false;
          prettyPrint: bool = true): Recallable =
  ## jobsCompaniesDelete
  ## Deletes the specified company.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the company to be deleted,
  ## such as, "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
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
  ##   disableFastProcess: bool
  ##                     : Deprecated. This field is not working anymore.
  ## 
  ## Optional.
  ## 
  ## If set to true, this call waits for all processing steps to complete
  ## before the job is cleaned up. Otherwise, the call returns while some
  ## steps are still taking place asynchronously, hence faster.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594194 = newJObject()
  var query_594195 = newJObject()
  add(query_594195, "upload_protocol", newJString(uploadProtocol))
  add(query_594195, "fields", newJString(fields))
  add(query_594195, "quotaUser", newJString(quotaUser))
  add(path_594194, "name", newJString(name))
  add(query_594195, "alt", newJString(alt))
  add(query_594195, "oauth_token", newJString(oauthToken))
  add(query_594195, "callback", newJString(callback))
  add(query_594195, "access_token", newJString(accessToken))
  add(query_594195, "uploadType", newJString(uploadType))
  add(query_594195, "key", newJString(key))
  add(query_594195, "$.xgafv", newJString(Xgafv))
  add(query_594195, "disableFastProcess", newJBool(disableFastProcess))
  add(query_594195, "prettyPrint", newJBool(prettyPrint))
  result = call_594193.call(path_594194, query_594195, nil, nil, nil)

var jobsCompaniesDelete* = Call_JobsCompaniesDelete_594176(
    name: "jobsCompaniesDelete", meth: HttpMethod.HttpDelete,
    host: "jobs.googleapis.com", route: "/v2/{name}",
    validator: validate_JobsCompaniesDelete_594177, base: "/",
    url: url_JobsCompaniesDelete_594178, schemes: {Scheme.Https})
type
  Call_JobsComplete_594218 = ref object of OpenApiRestCall_593421
proc url_JobsComplete_594220(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobsComplete_594219(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Completes the specified prefix with job keyword suggestions.
  ## Intended for use by a job search auto-complete search box.
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
  ##   scope: JString
  ##        : Optional. The scope of the completion. The defaults is CompletionScope.PUBLIC.
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : Required. The query used to generate suggestions.
  ##   type: JString
  ##       : Optional. The completion topic. The default is CompletionType.COMBINED.
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
  ##               : Required. The language of the query. This is
  ## the BCP-47 language code, such as "en-US" or "sr-Latn".
  ## For more information, see
  ## [Tags for Identifying Languages](https://tools.ietf.org/html/bcp47).
  ## 
  ## For CompletionType.JOB_TITLE type, only open jobs with same
  ## language_code are returned.
  ## 
  ## For CompletionType.COMPANY_NAME type,
  ## only companies having open jobs with same language_code are
  ## returned.
  ## 
  ## For CompletionType.COMBINED type, only open jobs with same
  ## language_code or companies having open jobs with same
  ## language_code are returned.
  ##   pageSize: JInt
  ##           : Required. Completion result count.
  ## The maximum allowed page size is 10.
  ##   companyName: JString
  ##              : Optional. If provided, restricts completion to the specified company.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594221 = query.getOrDefault("upload_protocol")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = nil)
  if valid_594221 != nil:
    section.add "upload_protocol", valid_594221
  var valid_594222 = query.getOrDefault("fields")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "fields", valid_594222
  var valid_594223 = query.getOrDefault("quotaUser")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = nil)
  if valid_594223 != nil:
    section.add "quotaUser", valid_594223
  var valid_594224 = query.getOrDefault("scope")
  valid_594224 = validateParameter(valid_594224, JString, required = false, default = newJString(
      "COMPLETION_SCOPE_UNSPECIFIED"))
  if valid_594224 != nil:
    section.add "scope", valid_594224
  var valid_594225 = query.getOrDefault("alt")
  valid_594225 = validateParameter(valid_594225, JString, required = false,
                                 default = newJString("json"))
  if valid_594225 != nil:
    section.add "alt", valid_594225
  var valid_594226 = query.getOrDefault("query")
  valid_594226 = validateParameter(valid_594226, JString, required = false,
                                 default = nil)
  if valid_594226 != nil:
    section.add "query", valid_594226
  var valid_594227 = query.getOrDefault("type")
  valid_594227 = validateParameter(valid_594227, JString, required = false, default = newJString(
      "COMPLETION_TYPE_UNSPECIFIED"))
  if valid_594227 != nil:
    section.add "type", valid_594227
  var valid_594228 = query.getOrDefault("oauth_token")
  valid_594228 = validateParameter(valid_594228, JString, required = false,
                                 default = nil)
  if valid_594228 != nil:
    section.add "oauth_token", valid_594228
  var valid_594229 = query.getOrDefault("callback")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = nil)
  if valid_594229 != nil:
    section.add "callback", valid_594229
  var valid_594230 = query.getOrDefault("access_token")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = nil)
  if valid_594230 != nil:
    section.add "access_token", valid_594230
  var valid_594231 = query.getOrDefault("uploadType")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = nil)
  if valid_594231 != nil:
    section.add "uploadType", valid_594231
  var valid_594232 = query.getOrDefault("key")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "key", valid_594232
  var valid_594233 = query.getOrDefault("$.xgafv")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = newJString("1"))
  if valid_594233 != nil:
    section.add "$.xgafv", valid_594233
  var valid_594234 = query.getOrDefault("languageCode")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "languageCode", valid_594234
  var valid_594235 = query.getOrDefault("pageSize")
  valid_594235 = validateParameter(valid_594235, JInt, required = false, default = nil)
  if valid_594235 != nil:
    section.add "pageSize", valid_594235
  var valid_594236 = query.getOrDefault("companyName")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "companyName", valid_594236
  var valid_594237 = query.getOrDefault("prettyPrint")
  valid_594237 = validateParameter(valid_594237, JBool, required = false,
                                 default = newJBool(true))
  if valid_594237 != nil:
    section.add "prettyPrint", valid_594237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594238: Call_JobsComplete_594218; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Completes the specified prefix with job keyword suggestions.
  ## Intended for use by a job search auto-complete search box.
  ## 
  let valid = call_594238.validator(path, query, header, formData, body)
  let scheme = call_594238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594238.url(scheme.get, call_594238.host, call_594238.base,
                         call_594238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594238, url, valid)

proc call*(call_594239: Call_JobsComplete_594218; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = "";
          scope: string = "COMPLETION_SCOPE_UNSPECIFIED"; alt: string = "json";
          query: string = ""; `type`: string = "COMPLETION_TYPE_UNSPECIFIED";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          languageCode: string = ""; pageSize: int = 0; companyName: string = "";
          prettyPrint: bool = true): Recallable =
  ## jobsComplete
  ## Completes the specified prefix with job keyword suggestions.
  ## Intended for use by a job search auto-complete search box.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   scope: string
  ##        : Optional. The scope of the completion. The defaults is CompletionScope.PUBLIC.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : Required. The query used to generate suggestions.
  ##   type: string
  ##       : Optional. The completion topic. The default is CompletionType.COMBINED.
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
  ##               : Required. The language of the query. This is
  ## the BCP-47 language code, such as "en-US" or "sr-Latn".
  ## For more information, see
  ## [Tags for Identifying Languages](https://tools.ietf.org/html/bcp47).
  ## 
  ## For CompletionType.JOB_TITLE type, only open jobs with same
  ## language_code are returned.
  ## 
  ## For CompletionType.COMPANY_NAME type,
  ## only companies having open jobs with same language_code are
  ## returned.
  ## 
  ## For CompletionType.COMBINED type, only open jobs with same
  ## language_code or companies having open jobs with same
  ## language_code are returned.
  ##   pageSize: int
  ##           : Required. Completion result count.
  ## The maximum allowed page size is 10.
  ##   companyName: string
  ##              : Optional. If provided, restricts completion to the specified company.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594240 = newJObject()
  add(query_594240, "upload_protocol", newJString(uploadProtocol))
  add(query_594240, "fields", newJString(fields))
  add(query_594240, "quotaUser", newJString(quotaUser))
  add(query_594240, "scope", newJString(scope))
  add(query_594240, "alt", newJString(alt))
  add(query_594240, "query", newJString(query))
  add(query_594240, "type", newJString(`type`))
  add(query_594240, "oauth_token", newJString(oauthToken))
  add(query_594240, "callback", newJString(callback))
  add(query_594240, "access_token", newJString(accessToken))
  add(query_594240, "uploadType", newJString(uploadType))
  add(query_594240, "key", newJString(key))
  add(query_594240, "$.xgafv", newJString(Xgafv))
  add(query_594240, "languageCode", newJString(languageCode))
  add(query_594240, "pageSize", newJInt(pageSize))
  add(query_594240, "companyName", newJString(companyName))
  add(query_594240, "prettyPrint", newJBool(prettyPrint))
  result = call_594239.call(nil, query_594240, nil, nil, nil)

var jobsComplete* = Call_JobsComplete_594218(name: "jobsComplete",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2:complete",
    validator: validate_JobsComplete_594219, base: "/", url: url_JobsComplete_594220,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
