
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Firebase Management
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The Firebase Management API enables programmatic setup and management of Firebase projects, including a project's Firebase resources and Firebase apps.
## 
## https://firebase.google.com
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
  gcpServiceName = "firebase"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FirebaseAvailableProjectsList_578610 = ref object of OpenApiRestCall_578339
proc url_FirebaseAvailableProjectsList_578612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FirebaseAvailableProjectsList_578611(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of [Google Cloud Platform (GCP) `Projects`]
  ## (https://cloud.google.com/resource-manager/reference/rest/v1/projects)
  ## that are available to have Firebase resources added to them.
  ## <br>
  ## <br>A GCP `Project` will only be returned if:
  ## <ol>
  ##   <li><p>The caller has sufficient
  ##          [Google IAM](https://cloud.google.com/iam) permissions to call
  ##          AddFirebase.</p></li>
  ##   <li><p>The GCP `Project` is not already a FirebaseProject.</p></li>
  ##   <li><p>The GCP `Project` is not in an Organization which has policies
  ##          that prevent Firebase resources from being added.</p></li>
  ## </ol>
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
  ##           : The maximum number of GCP `Projects` to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), the server
  ## will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token returned from a previous call to `ListAvailableProjects`
  ## indicating where in the set of GCP `Projects` to resume listing.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578724 = query.getOrDefault("key")
  valid_578724 = validateParameter(valid_578724, JString, required = false,
                                 default = nil)
  if valid_578724 != nil:
    section.add "key", valid_578724
  var valid_578738 = query.getOrDefault("prettyPrint")
  valid_578738 = validateParameter(valid_578738, JBool, required = false,
                                 default = newJBool(true))
  if valid_578738 != nil:
    section.add "prettyPrint", valid_578738
  var valid_578739 = query.getOrDefault("oauth_token")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "oauth_token", valid_578739
  var valid_578740 = query.getOrDefault("$.xgafv")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = newJString("1"))
  if valid_578740 != nil:
    section.add "$.xgafv", valid_578740
  var valid_578741 = query.getOrDefault("pageSize")
  valid_578741 = validateParameter(valid_578741, JInt, required = false, default = nil)
  if valid_578741 != nil:
    section.add "pageSize", valid_578741
  var valid_578742 = query.getOrDefault("alt")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = newJString("json"))
  if valid_578742 != nil:
    section.add "alt", valid_578742
  var valid_578743 = query.getOrDefault("uploadType")
  valid_578743 = validateParameter(valid_578743, JString, required = false,
                                 default = nil)
  if valid_578743 != nil:
    section.add "uploadType", valid_578743
  var valid_578744 = query.getOrDefault("quotaUser")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = nil)
  if valid_578744 != nil:
    section.add "quotaUser", valid_578744
  var valid_578745 = query.getOrDefault("pageToken")
  valid_578745 = validateParameter(valid_578745, JString, required = false,
                                 default = nil)
  if valid_578745 != nil:
    section.add "pageToken", valid_578745
  var valid_578746 = query.getOrDefault("callback")
  valid_578746 = validateParameter(valid_578746, JString, required = false,
                                 default = nil)
  if valid_578746 != nil:
    section.add "callback", valid_578746
  var valid_578747 = query.getOrDefault("fields")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "fields", valid_578747
  var valid_578748 = query.getOrDefault("access_token")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "access_token", valid_578748
  var valid_578749 = query.getOrDefault("upload_protocol")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "upload_protocol", valid_578749
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578772: Call_FirebaseAvailableProjectsList_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of [Google Cloud Platform (GCP) `Projects`]
  ## (https://cloud.google.com/resource-manager/reference/rest/v1/projects)
  ## that are available to have Firebase resources added to them.
  ## <br>
  ## <br>A GCP `Project` will only be returned if:
  ## <ol>
  ##   <li><p>The caller has sufficient
  ##          [Google IAM](https://cloud.google.com/iam) permissions to call
  ##          AddFirebase.</p></li>
  ##   <li><p>The GCP `Project` is not already a FirebaseProject.</p></li>
  ##   <li><p>The GCP `Project` is not in an Organization which has policies
  ##          that prevent Firebase resources from being added.</p></li>
  ## </ol>
  ## 
  let valid = call_578772.validator(path, query, header, formData, body)
  let scheme = call_578772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578772.url(scheme.get, call_578772.host, call_578772.base,
                         call_578772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578772, url, valid)

proc call*(call_578843: Call_FirebaseAvailableProjectsList_578610;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseAvailableProjectsList
  ## Returns a list of [Google Cloud Platform (GCP) `Projects`]
  ## (https://cloud.google.com/resource-manager/reference/rest/v1/projects)
  ## that are available to have Firebase resources added to them.
  ## <br>
  ## <br>A GCP `Project` will only be returned if:
  ## <ol>
  ##   <li><p>The caller has sufficient
  ##          [Google IAM](https://cloud.google.com/iam) permissions to call
  ##          AddFirebase.</p></li>
  ##   <li><p>The GCP `Project` is not already a FirebaseProject.</p></li>
  ##   <li><p>The GCP `Project` is not in an Organization which has policies
  ##          that prevent Firebase resources from being added.</p></li>
  ## </ol>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of GCP `Projects` to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), the server
  ## will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Token returned from a previous call to `ListAvailableProjects`
  ## indicating where in the set of GCP `Projects` to resume listing.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578844 = newJObject()
  add(query_578844, "key", newJString(key))
  add(query_578844, "prettyPrint", newJBool(prettyPrint))
  add(query_578844, "oauth_token", newJString(oauthToken))
  add(query_578844, "$.xgafv", newJString(Xgafv))
  add(query_578844, "pageSize", newJInt(pageSize))
  add(query_578844, "alt", newJString(alt))
  add(query_578844, "uploadType", newJString(uploadType))
  add(query_578844, "quotaUser", newJString(quotaUser))
  add(query_578844, "pageToken", newJString(pageToken))
  add(query_578844, "callback", newJString(callback))
  add(query_578844, "fields", newJString(fields))
  add(query_578844, "access_token", newJString(accessToken))
  add(query_578844, "upload_protocol", newJString(uploadProtocol))
  result = call_578843.call(nil, query_578844, nil, nil, nil)

var firebaseAvailableProjectsList* = Call_FirebaseAvailableProjectsList_578610(
    name: "firebaseAvailableProjectsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/availableProjects",
    validator: validate_FirebaseAvailableProjectsList_578611, base: "/",
    url: url_FirebaseAvailableProjectsList_578612, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsList_578884 = ref object of OpenApiRestCall_578339
proc url_FirebaseProjectsList_578886(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FirebaseProjectsList_578885(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists each FirebaseProject accessible to the caller.
  ## <br>
  ## <br>The elements are returned in no particular order, but they will be a
  ## consistent view of the Projects when additional requests are made with a
  ## `pageToken`.
  ## <br>
  ## <br>This method is eventually consistent with Project mutations, which
  ## means newly provisioned Projects and recent modifications to existing
  ## Projects might not be reflected in the set of Projects. The list will
  ## include only ACTIVE Projects.
  ## <br>
  ## <br>Use
  ## GetFirebaseProject
  ## for consistent reads as well as for additional Project details.
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
  ##           : The maximum number of Projects to return in the response.
  ## <br>
  ## <br>The server may return fewer than this at its discretion.
  ## If no value is specified (or too large a value is specified), the server
  ## will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token returned from a previous call to `ListFirebaseProjects` indicating
  ## where in the set of Projects to resume listing.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578887 = query.getOrDefault("key")
  valid_578887 = validateParameter(valid_578887, JString, required = false,
                                 default = nil)
  if valid_578887 != nil:
    section.add "key", valid_578887
  var valid_578888 = query.getOrDefault("prettyPrint")
  valid_578888 = validateParameter(valid_578888, JBool, required = false,
                                 default = newJBool(true))
  if valid_578888 != nil:
    section.add "prettyPrint", valid_578888
  var valid_578889 = query.getOrDefault("oauth_token")
  valid_578889 = validateParameter(valid_578889, JString, required = false,
                                 default = nil)
  if valid_578889 != nil:
    section.add "oauth_token", valid_578889
  var valid_578890 = query.getOrDefault("$.xgafv")
  valid_578890 = validateParameter(valid_578890, JString, required = false,
                                 default = newJString("1"))
  if valid_578890 != nil:
    section.add "$.xgafv", valid_578890
  var valid_578891 = query.getOrDefault("pageSize")
  valid_578891 = validateParameter(valid_578891, JInt, required = false, default = nil)
  if valid_578891 != nil:
    section.add "pageSize", valid_578891
  var valid_578892 = query.getOrDefault("alt")
  valid_578892 = validateParameter(valid_578892, JString, required = false,
                                 default = newJString("json"))
  if valid_578892 != nil:
    section.add "alt", valid_578892
  var valid_578893 = query.getOrDefault("uploadType")
  valid_578893 = validateParameter(valid_578893, JString, required = false,
                                 default = nil)
  if valid_578893 != nil:
    section.add "uploadType", valid_578893
  var valid_578894 = query.getOrDefault("quotaUser")
  valid_578894 = validateParameter(valid_578894, JString, required = false,
                                 default = nil)
  if valid_578894 != nil:
    section.add "quotaUser", valid_578894
  var valid_578895 = query.getOrDefault("pageToken")
  valid_578895 = validateParameter(valid_578895, JString, required = false,
                                 default = nil)
  if valid_578895 != nil:
    section.add "pageToken", valid_578895
  var valid_578896 = query.getOrDefault("callback")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = nil)
  if valid_578896 != nil:
    section.add "callback", valid_578896
  var valid_578897 = query.getOrDefault("fields")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "fields", valid_578897
  var valid_578898 = query.getOrDefault("access_token")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "access_token", valid_578898
  var valid_578899 = query.getOrDefault("upload_protocol")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "upload_protocol", valid_578899
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578900: Call_FirebaseProjectsList_578884; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists each FirebaseProject accessible to the caller.
  ## <br>
  ## <br>The elements are returned in no particular order, but they will be a
  ## consistent view of the Projects when additional requests are made with a
  ## `pageToken`.
  ## <br>
  ## <br>This method is eventually consistent with Project mutations, which
  ## means newly provisioned Projects and recent modifications to existing
  ## Projects might not be reflected in the set of Projects. The list will
  ## include only ACTIVE Projects.
  ## <br>
  ## <br>Use
  ## GetFirebaseProject
  ## for consistent reads as well as for additional Project details.
  ## 
  let valid = call_578900.validator(path, query, header, formData, body)
  let scheme = call_578900.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578900.url(scheme.get, call_578900.host, call_578900.base,
                         call_578900.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578900, url, valid)

proc call*(call_578901: Call_FirebaseProjectsList_578884; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsList
  ## Lists each FirebaseProject accessible to the caller.
  ## <br>
  ## <br>The elements are returned in no particular order, but they will be a
  ## consistent view of the Projects when additional requests are made with a
  ## `pageToken`.
  ## <br>
  ## <br>This method is eventually consistent with Project mutations, which
  ## means newly provisioned Projects and recent modifications to existing
  ## Projects might not be reflected in the set of Projects. The list will
  ## include only ACTIVE Projects.
  ## <br>
  ## <br>Use
  ## GetFirebaseProject
  ## for consistent reads as well as for additional Project details.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of Projects to return in the response.
  ## <br>
  ## <br>The server may return fewer than this at its discretion.
  ## If no value is specified (or too large a value is specified), the server
  ## will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Token returned from a previous call to `ListFirebaseProjects` indicating
  ## where in the set of Projects to resume listing.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578902 = newJObject()
  add(query_578902, "key", newJString(key))
  add(query_578902, "prettyPrint", newJBool(prettyPrint))
  add(query_578902, "oauth_token", newJString(oauthToken))
  add(query_578902, "$.xgafv", newJString(Xgafv))
  add(query_578902, "pageSize", newJInt(pageSize))
  add(query_578902, "alt", newJString(alt))
  add(query_578902, "uploadType", newJString(uploadType))
  add(query_578902, "quotaUser", newJString(quotaUser))
  add(query_578902, "pageToken", newJString(pageToken))
  add(query_578902, "callback", newJString(callback))
  add(query_578902, "fields", newJString(fields))
  add(query_578902, "access_token", newJString(accessToken))
  add(query_578902, "upload_protocol", newJString(uploadProtocol))
  result = call_578901.call(nil, query_578902, nil, nil, nil)

var firebaseProjectsList* = Call_FirebaseProjectsList_578884(
    name: "firebaseProjectsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/projects",
    validator: validate_FirebaseProjectsList_578885, base: "/",
    url: url_FirebaseProjectsList_578886, schemes: {Scheme.Https})
type
  Call_FirebaseOperationsGet_578903 = ref object of OpenApiRestCall_578339
proc url_FirebaseOperationsGet_578905(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseOperationsGet_578904(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_578920 = path.getOrDefault("name")
  valid_578920 = validateParameter(valid_578920, JString, required = true,
                                 default = nil)
  if valid_578920 != nil:
    section.add "name", valid_578920
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
  if body != nil:
    result.add "body", body

proc call*(call_578932: Call_FirebaseOperationsGet_578903; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_578932.validator(path, query, header, formData, body)
  let scheme = call_578932.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578932.url(scheme.get, call_578932.host, call_578932.base,
                         call_578932.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578932, url, valid)

proc call*(call_578933: Call_FirebaseOperationsGet_578903; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaseOperationsGet
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
  var path_578934 = newJObject()
  var query_578935 = newJObject()
  add(query_578935, "key", newJString(key))
  add(query_578935, "prettyPrint", newJBool(prettyPrint))
  add(query_578935, "oauth_token", newJString(oauthToken))
  add(query_578935, "$.xgafv", newJString(Xgafv))
  add(query_578935, "alt", newJString(alt))
  add(query_578935, "uploadType", newJString(uploadType))
  add(query_578935, "quotaUser", newJString(quotaUser))
  add(path_578934, "name", newJString(name))
  add(query_578935, "callback", newJString(callback))
  add(query_578935, "fields", newJString(fields))
  add(query_578935, "access_token", newJString(accessToken))
  add(query_578935, "upload_protocol", newJString(uploadProtocol))
  result = call_578933.call(path_578934, query_578935, nil, nil, nil)

var firebaseOperationsGet* = Call_FirebaseOperationsGet_578903(
    name: "firebaseOperationsGet", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebaseOperationsGet_578904, base: "/",
    url: url_FirebaseOperationsGet_578905, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsIosAppsPatch_578955 = ref object of OpenApiRestCall_578339
proc url_FirebaseProjectsIosAppsPatch_578957(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsIosAppsPatch_578956(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the attributes of the IosApp identified by the specified
  ## resource name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The fully qualified resource name of the App, in the format:
  ## <br><code>projects/<var>projectId</var>/iosApps/<var>appId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578958 = path.getOrDefault("name")
  valid_578958 = validateParameter(valid_578958, JString, required = true,
                                 default = nil)
  if valid_578958 != nil:
    section.add "name", valid_578958
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
  ##   updateMask: JString
  ##             : Specifies which fields to update.
  ## <br>Note that the fields `name`, `appId`, `projectId`, and `bundleId`
  ## are all immutable.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578959 = query.getOrDefault("key")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "key", valid_578959
  var valid_578960 = query.getOrDefault("prettyPrint")
  valid_578960 = validateParameter(valid_578960, JBool, required = false,
                                 default = newJBool(true))
  if valid_578960 != nil:
    section.add "prettyPrint", valid_578960
  var valid_578961 = query.getOrDefault("oauth_token")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "oauth_token", valid_578961
  var valid_578962 = query.getOrDefault("$.xgafv")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = newJString("1"))
  if valid_578962 != nil:
    section.add "$.xgafv", valid_578962
  var valid_578963 = query.getOrDefault("alt")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = newJString("json"))
  if valid_578963 != nil:
    section.add "alt", valid_578963
  var valid_578964 = query.getOrDefault("uploadType")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "uploadType", valid_578964
  var valid_578965 = query.getOrDefault("quotaUser")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "quotaUser", valid_578965
  var valid_578966 = query.getOrDefault("updateMask")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "updateMask", valid_578966
  var valid_578967 = query.getOrDefault("callback")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "callback", valid_578967
  var valid_578968 = query.getOrDefault("fields")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "fields", valid_578968
  var valid_578969 = query.getOrDefault("access_token")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "access_token", valid_578969
  var valid_578970 = query.getOrDefault("upload_protocol")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "upload_protocol", valid_578970
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

proc call*(call_578972: Call_FirebaseProjectsIosAppsPatch_578955; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the attributes of the IosApp identified by the specified
  ## resource name.
  ## 
  let valid = call_578972.validator(path, query, header, formData, body)
  let scheme = call_578972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578972.url(scheme.get, call_578972.host, call_578972.base,
                         call_578972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578972, url, valid)

proc call*(call_578973: Call_FirebaseProjectsIosAppsPatch_578955; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; updateMask: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsIosAppsPatch
  ## Updates the attributes of the IosApp identified by the specified
  ## resource name.
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
  ##       : The fully qualified resource name of the App, in the format:
  ## <br><code>projects/<var>projectId</var>/iosApps/<var>appId</var></code>
  ##   updateMask: string
  ##             : Specifies which fields to update.
  ## <br>Note that the fields `name`, `appId`, `projectId`, and `bundleId`
  ## are all immutable.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578974 = newJObject()
  var query_578975 = newJObject()
  var body_578976 = newJObject()
  add(query_578975, "key", newJString(key))
  add(query_578975, "prettyPrint", newJBool(prettyPrint))
  add(query_578975, "oauth_token", newJString(oauthToken))
  add(query_578975, "$.xgafv", newJString(Xgafv))
  add(query_578975, "alt", newJString(alt))
  add(query_578975, "uploadType", newJString(uploadType))
  add(query_578975, "quotaUser", newJString(quotaUser))
  add(path_578974, "name", newJString(name))
  add(query_578975, "updateMask", newJString(updateMask))
  if body != nil:
    body_578976 = body
  add(query_578975, "callback", newJString(callback))
  add(query_578975, "fields", newJString(fields))
  add(query_578975, "access_token", newJString(accessToken))
  add(query_578975, "upload_protocol", newJString(uploadProtocol))
  result = call_578973.call(path_578974, query_578975, nil, nil, body_578976)

var firebaseProjectsIosAppsPatch* = Call_FirebaseProjectsIosAppsPatch_578955(
    name: "firebaseProjectsIosAppsPatch", meth: HttpMethod.HttpPatch,
    host: "firebase.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebaseProjectsIosAppsPatch_578956, base: "/",
    url: url_FirebaseProjectsIosAppsPatch_578957, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsShaDelete_578936 = ref object of OpenApiRestCall_578339
proc url_FirebaseProjectsAndroidAppsShaDelete_578938(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsAndroidAppsShaDelete_578937(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a SHA certificate from the specified AndroidApp.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The fully qualified resource name of the `sha-key`, in the format:
  ## 
  ## <br><code>projects/<var>projectId</var>/androidApps/<var>appId</var>/sha/<var>shaId</var></code>
  ## <br>You can obtain the full name from the response of
  ## [`ListShaCertificates`](../projects.androidApps.sha/list) or the original
  ## [`CreateShaCertificate`](../projects.androidApps.sha/create).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578939 = path.getOrDefault("name")
  valid_578939 = validateParameter(valid_578939, JString, required = true,
                                 default = nil)
  if valid_578939 != nil:
    section.add "name", valid_578939
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
  var valid_578940 = query.getOrDefault("key")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "key", valid_578940
  var valid_578941 = query.getOrDefault("prettyPrint")
  valid_578941 = validateParameter(valid_578941, JBool, required = false,
                                 default = newJBool(true))
  if valid_578941 != nil:
    section.add "prettyPrint", valid_578941
  var valid_578942 = query.getOrDefault("oauth_token")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "oauth_token", valid_578942
  var valid_578943 = query.getOrDefault("$.xgafv")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = newJString("1"))
  if valid_578943 != nil:
    section.add "$.xgafv", valid_578943
  var valid_578944 = query.getOrDefault("alt")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = newJString("json"))
  if valid_578944 != nil:
    section.add "alt", valid_578944
  var valid_578945 = query.getOrDefault("uploadType")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "uploadType", valid_578945
  var valid_578946 = query.getOrDefault("quotaUser")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "quotaUser", valid_578946
  var valid_578947 = query.getOrDefault("callback")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "callback", valid_578947
  var valid_578948 = query.getOrDefault("fields")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "fields", valid_578948
  var valid_578949 = query.getOrDefault("access_token")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "access_token", valid_578949
  var valid_578950 = query.getOrDefault("upload_protocol")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "upload_protocol", valid_578950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578951: Call_FirebaseProjectsAndroidAppsShaDelete_578936;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a SHA certificate from the specified AndroidApp.
  ## 
  let valid = call_578951.validator(path, query, header, formData, body)
  let scheme = call_578951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578951.url(scheme.get, call_578951.host, call_578951.base,
                         call_578951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578951, url, valid)

proc call*(call_578952: Call_FirebaseProjectsAndroidAppsShaDelete_578936;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsAndroidAppsShaDelete
  ## Removes a SHA certificate from the specified AndroidApp.
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
  ##       : The fully qualified resource name of the `sha-key`, in the format:
  ## 
  ## <br><code>projects/<var>projectId</var>/androidApps/<var>appId</var>/sha/<var>shaId</var></code>
  ## <br>You can obtain the full name from the response of
  ## [`ListShaCertificates`](../projects.androidApps.sha/list) or the original
  ## [`CreateShaCertificate`](../projects.androidApps.sha/create).
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578953 = newJObject()
  var query_578954 = newJObject()
  add(query_578954, "key", newJString(key))
  add(query_578954, "prettyPrint", newJBool(prettyPrint))
  add(query_578954, "oauth_token", newJString(oauthToken))
  add(query_578954, "$.xgafv", newJString(Xgafv))
  add(query_578954, "alt", newJString(alt))
  add(query_578954, "uploadType", newJString(uploadType))
  add(query_578954, "quotaUser", newJString(quotaUser))
  add(path_578953, "name", newJString(name))
  add(query_578954, "callback", newJString(callback))
  add(query_578954, "fields", newJString(fields))
  add(query_578954, "access_token", newJString(accessToken))
  add(query_578954, "upload_protocol", newJString(uploadProtocol))
  result = call_578952.call(path_578953, query_578954, nil, nil, nil)

var firebaseProjectsAndroidAppsShaDelete* = Call_FirebaseProjectsAndroidAppsShaDelete_578936(
    name: "firebaseProjectsAndroidAppsShaDelete", meth: HttpMethod.HttpDelete,
    host: "firebase.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebaseProjectsAndroidAppsShaDelete_578937, base: "/",
    url: url_FirebaseProjectsAndroidAppsShaDelete_578938, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsCreate_578998 = ref object of OpenApiRestCall_578339
proc url_FirebaseProjectsAndroidAppsCreate_579000(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/androidApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsAndroidAppsCreate_578999(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests that a new AndroidApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579001 = path.getOrDefault("parent")
  valid_579001 = validateParameter(valid_579001, JString, required = true,
                                 default = nil)
  if valid_579001 != nil:
    section.add "parent", valid_579001
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
  var valid_579002 = query.getOrDefault("key")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "key", valid_579002
  var valid_579003 = query.getOrDefault("prettyPrint")
  valid_579003 = validateParameter(valid_579003, JBool, required = false,
                                 default = newJBool(true))
  if valid_579003 != nil:
    section.add "prettyPrint", valid_579003
  var valid_579004 = query.getOrDefault("oauth_token")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "oauth_token", valid_579004
  var valid_579005 = query.getOrDefault("$.xgafv")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = newJString("1"))
  if valid_579005 != nil:
    section.add "$.xgafv", valid_579005
  var valid_579006 = query.getOrDefault("alt")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = newJString("json"))
  if valid_579006 != nil:
    section.add "alt", valid_579006
  var valid_579007 = query.getOrDefault("uploadType")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "uploadType", valid_579007
  var valid_579008 = query.getOrDefault("quotaUser")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "quotaUser", valid_579008
  var valid_579009 = query.getOrDefault("callback")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "callback", valid_579009
  var valid_579010 = query.getOrDefault("fields")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "fields", valid_579010
  var valid_579011 = query.getOrDefault("access_token")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "access_token", valid_579011
  var valid_579012 = query.getOrDefault("upload_protocol")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "upload_protocol", valid_579012
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

proc call*(call_579014: Call_FirebaseProjectsAndroidAppsCreate_578998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests that a new AndroidApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  let valid = call_579014.validator(path, query, header, formData, body)
  let scheme = call_579014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579014.url(scheme.get, call_579014.host, call_579014.base,
                         call_579014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579014, url, valid)

proc call*(call_579015: Call_FirebaseProjectsAndroidAppsCreate_578998;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsAndroidAppsCreate
  ## Requests that a new AndroidApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
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
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579016 = newJObject()
  var query_579017 = newJObject()
  var body_579018 = newJObject()
  add(query_579017, "key", newJString(key))
  add(query_579017, "prettyPrint", newJBool(prettyPrint))
  add(query_579017, "oauth_token", newJString(oauthToken))
  add(query_579017, "$.xgafv", newJString(Xgafv))
  add(query_579017, "alt", newJString(alt))
  add(query_579017, "uploadType", newJString(uploadType))
  add(query_579017, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579018 = body
  add(query_579017, "callback", newJString(callback))
  add(path_579016, "parent", newJString(parent))
  add(query_579017, "fields", newJString(fields))
  add(query_579017, "access_token", newJString(accessToken))
  add(query_579017, "upload_protocol", newJString(uploadProtocol))
  result = call_579015.call(path_579016, query_579017, nil, nil, body_579018)

var firebaseProjectsAndroidAppsCreate* = Call_FirebaseProjectsAndroidAppsCreate_578998(
    name: "firebaseProjectsAndroidAppsCreate", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/androidApps",
    validator: validate_FirebaseProjectsAndroidAppsCreate_578999, base: "/",
    url: url_FirebaseProjectsAndroidAppsCreate_579000, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsList_578977 = ref object of OpenApiRestCall_578339
proc url_FirebaseProjectsAndroidAppsList_578979(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/androidApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsAndroidAppsList_578978(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists each AndroidApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_578980 = path.getOrDefault("parent")
  valid_578980 = validateParameter(valid_578980, JString, required = true,
                                 default = nil)
  if valid_578980 != nil:
    section.add "parent", valid_578980
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
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token returned from a previous call to `ListAndroidApps` indicating where
  ## in the set of Apps to resume listing.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578981 = query.getOrDefault("key")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "key", valid_578981
  var valid_578982 = query.getOrDefault("prettyPrint")
  valid_578982 = validateParameter(valid_578982, JBool, required = false,
                                 default = newJBool(true))
  if valid_578982 != nil:
    section.add "prettyPrint", valid_578982
  var valid_578983 = query.getOrDefault("oauth_token")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "oauth_token", valid_578983
  var valid_578984 = query.getOrDefault("$.xgafv")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = newJString("1"))
  if valid_578984 != nil:
    section.add "$.xgafv", valid_578984
  var valid_578985 = query.getOrDefault("pageSize")
  valid_578985 = validateParameter(valid_578985, JInt, required = false, default = nil)
  if valid_578985 != nil:
    section.add "pageSize", valid_578985
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
  var valid_578989 = query.getOrDefault("pageToken")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "pageToken", valid_578989
  var valid_578990 = query.getOrDefault("callback")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "callback", valid_578990
  var valid_578991 = query.getOrDefault("fields")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "fields", valid_578991
  var valid_578992 = query.getOrDefault("access_token")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "access_token", valid_578992
  var valid_578993 = query.getOrDefault("upload_protocol")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "upload_protocol", valid_578993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578994: Call_FirebaseProjectsAndroidAppsList_578977;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists each AndroidApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  let valid = call_578994.validator(path, query, header, formData, body)
  let scheme = call_578994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578994.url(scheme.get, call_578994.host, call_578994.base,
                         call_578994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578994, url, valid)

proc call*(call_578995: Call_FirebaseProjectsAndroidAppsList_578977;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsAndroidAppsList
  ## Lists each AndroidApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Token returned from a previous call to `ListAndroidApps` indicating where
  ## in the set of Apps to resume listing.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578996 = newJObject()
  var query_578997 = newJObject()
  add(query_578997, "key", newJString(key))
  add(query_578997, "prettyPrint", newJBool(prettyPrint))
  add(query_578997, "oauth_token", newJString(oauthToken))
  add(query_578997, "$.xgafv", newJString(Xgafv))
  add(query_578997, "pageSize", newJInt(pageSize))
  add(query_578997, "alt", newJString(alt))
  add(query_578997, "uploadType", newJString(uploadType))
  add(query_578997, "quotaUser", newJString(quotaUser))
  add(query_578997, "pageToken", newJString(pageToken))
  add(query_578997, "callback", newJString(callback))
  add(path_578996, "parent", newJString(parent))
  add(query_578997, "fields", newJString(fields))
  add(query_578997, "access_token", newJString(accessToken))
  add(query_578997, "upload_protocol", newJString(uploadProtocol))
  result = call_578995.call(path_578996, query_578997, nil, nil, nil)

var firebaseProjectsAndroidAppsList* = Call_FirebaseProjectsAndroidAppsList_578977(
    name: "firebaseProjectsAndroidAppsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/androidApps",
    validator: validate_FirebaseProjectsAndroidAppsList_578978, base: "/",
    url: url_FirebaseProjectsAndroidAppsList_578979, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAvailableLocationsList_579019 = ref object of OpenApiRestCall_578339
proc url_FirebaseProjectsAvailableLocationsList_579021(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/availableLocations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsAvailableLocationsList_579020(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of valid Google Cloud Platform (GCP) resource locations for
  ## the specified Project (including a FirebaseProject).
  ## <br>
  ## <br>The default GCP resource location of a project defines the geographical
  ## location where project resources, such as Cloud Firestore, will be
  ## provisioned by default.
  ## <br>
  ## <br>The returned list are the available
  ## [GCP resource
  ## locations](https://firebase.google.com/docs/projects/locations). <br>
  ## <br>This call checks for any location restrictions for the specified
  ## Project and, thus, might return a subset of all possible GCP resource
  ## locations. To list all GCP resource locations (regardless of any
  ## restrictions), call the endpoint without specifying a `projectId` (that is,
  ## `/v1beta1/{parent=projects/-}/listAvailableLocations`).
  ## <br>
  ## <br>To call `ListAvailableLocations` with a specified project, a member
  ## must be at minimum a Viewer of the project. Calls without a specified
  ## project do not require any specific project permissions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The Project for which to list GCP resource locations, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ## <br>If no project is specified (that is, `projects/-`), the returned list
  ## does not take into account org-specific or project-specific location
  ## restrictions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579022 = path.getOrDefault("parent")
  valid_579022 = validateParameter(valid_579022, JString, required = true,
                                 default = nil)
  if valid_579022 != nil:
    section.add "parent", valid_579022
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
  ##           : The maximum number of locations to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token returned from a previous call to `ListAvailableLocations` indicating
  ## where in the list of locations to resume listing.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579023 = query.getOrDefault("key")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "key", valid_579023
  var valid_579024 = query.getOrDefault("prettyPrint")
  valid_579024 = validateParameter(valid_579024, JBool, required = false,
                                 default = newJBool(true))
  if valid_579024 != nil:
    section.add "prettyPrint", valid_579024
  var valid_579025 = query.getOrDefault("oauth_token")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "oauth_token", valid_579025
  var valid_579026 = query.getOrDefault("$.xgafv")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = newJString("1"))
  if valid_579026 != nil:
    section.add "$.xgafv", valid_579026
  var valid_579027 = query.getOrDefault("pageSize")
  valid_579027 = validateParameter(valid_579027, JInt, required = false, default = nil)
  if valid_579027 != nil:
    section.add "pageSize", valid_579027
  var valid_579028 = query.getOrDefault("alt")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = newJString("json"))
  if valid_579028 != nil:
    section.add "alt", valid_579028
  var valid_579029 = query.getOrDefault("uploadType")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "uploadType", valid_579029
  var valid_579030 = query.getOrDefault("quotaUser")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "quotaUser", valid_579030
  var valid_579031 = query.getOrDefault("pageToken")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "pageToken", valid_579031
  var valid_579032 = query.getOrDefault("callback")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "callback", valid_579032
  var valid_579033 = query.getOrDefault("fields")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "fields", valid_579033
  var valid_579034 = query.getOrDefault("access_token")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "access_token", valid_579034
  var valid_579035 = query.getOrDefault("upload_protocol")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "upload_protocol", valid_579035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579036: Call_FirebaseProjectsAvailableLocationsList_579019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of valid Google Cloud Platform (GCP) resource locations for
  ## the specified Project (including a FirebaseProject).
  ## <br>
  ## <br>The default GCP resource location of a project defines the geographical
  ## location where project resources, such as Cloud Firestore, will be
  ## provisioned by default.
  ## <br>
  ## <br>The returned list are the available
  ## [GCP resource
  ## locations](https://firebase.google.com/docs/projects/locations). <br>
  ## <br>This call checks for any location restrictions for the specified
  ## Project and, thus, might return a subset of all possible GCP resource
  ## locations. To list all GCP resource locations (regardless of any
  ## restrictions), call the endpoint without specifying a `projectId` (that is,
  ## `/v1beta1/{parent=projects/-}/listAvailableLocations`).
  ## <br>
  ## <br>To call `ListAvailableLocations` with a specified project, a member
  ## must be at minimum a Viewer of the project. Calls without a specified
  ## project do not require any specific project permissions.
  ## 
  let valid = call_579036.validator(path, query, header, formData, body)
  let scheme = call_579036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579036.url(scheme.get, call_579036.host, call_579036.base,
                         call_579036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579036, url, valid)

proc call*(call_579037: Call_FirebaseProjectsAvailableLocationsList_579019;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsAvailableLocationsList
  ## Returns a list of valid Google Cloud Platform (GCP) resource locations for
  ## the specified Project (including a FirebaseProject).
  ## <br>
  ## <br>The default GCP resource location of a project defines the geographical
  ## location where project resources, such as Cloud Firestore, will be
  ## provisioned by default.
  ## <br>
  ## <br>The returned list are the available
  ## [GCP resource
  ## locations](https://firebase.google.com/docs/projects/locations). <br>
  ## <br>This call checks for any location restrictions for the specified
  ## Project and, thus, might return a subset of all possible GCP resource
  ## locations. To list all GCP resource locations (regardless of any
  ## restrictions), call the endpoint without specifying a `projectId` (that is,
  ## `/v1beta1/{parent=projects/-}/listAvailableLocations`).
  ## <br>
  ## <br>To call `ListAvailableLocations` with a specified project, a member
  ## must be at minimum a Viewer of the project. Calls without a specified
  ## project do not require any specific project permissions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of locations to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Token returned from a previous call to `ListAvailableLocations` indicating
  ## where in the list of locations to resume listing.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The Project for which to list GCP resource locations, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ## <br>If no project is specified (that is, `projects/-`), the returned list
  ## does not take into account org-specific or project-specific location
  ## restrictions.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579038 = newJObject()
  var query_579039 = newJObject()
  add(query_579039, "key", newJString(key))
  add(query_579039, "prettyPrint", newJBool(prettyPrint))
  add(query_579039, "oauth_token", newJString(oauthToken))
  add(query_579039, "$.xgafv", newJString(Xgafv))
  add(query_579039, "pageSize", newJInt(pageSize))
  add(query_579039, "alt", newJString(alt))
  add(query_579039, "uploadType", newJString(uploadType))
  add(query_579039, "quotaUser", newJString(quotaUser))
  add(query_579039, "pageToken", newJString(pageToken))
  add(query_579039, "callback", newJString(callback))
  add(path_579038, "parent", newJString(parent))
  add(query_579039, "fields", newJString(fields))
  add(query_579039, "access_token", newJString(accessToken))
  add(query_579039, "upload_protocol", newJString(uploadProtocol))
  result = call_579037.call(path_579038, query_579039, nil, nil, nil)

var firebaseProjectsAvailableLocationsList* = Call_FirebaseProjectsAvailableLocationsList_579019(
    name: "firebaseProjectsAvailableLocationsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com",
    route: "/v1beta1/{parent}/availableLocations",
    validator: validate_FirebaseProjectsAvailableLocationsList_579020, base: "/",
    url: url_FirebaseProjectsAvailableLocationsList_579021,
    schemes: {Scheme.Https})
type
  Call_FirebaseProjectsDefaultLocationFinalize_579040 = ref object of OpenApiRestCall_578339
proc url_FirebaseProjectsDefaultLocationFinalize_579042(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/defaultLocation:finalize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsDefaultLocationFinalize_579041(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the default Google Cloud Platform (GCP) resource location for the
  ## specified FirebaseProject.
  ## <br>
  ## <br>This method creates an App Engine application with a
  ## [default Cloud Storage
  ## bucket](https://cloud.google.com/appengine/docs/standard/python/googlecloudstorageclient/setting-up-cloud-storage#activating_a_cloud_storage_bucket),
  ## located in the specified
  ## [`location_id`](#body.request_body.FIELDS.location_id).
  ## This location must be one of the available
  ## [GCP resource
  ## locations](https://firebase.google.com/docs/projects/locations). <br>
  ## <br>After the default GCP resource location is finalized, or if it was
  ## already set, it cannot be changed. The default GCP resource location for
  ## the specified FirebaseProject might already be set because either the
  ## GCP `Project` already has an App Engine application or
  ## `FinalizeDefaultLocation` was previously called with a specified
  ## `location_id`. Any new calls to `FinalizeDefaultLocation` with a
  ## <em>different</em> specified `location_id` will return a 409 error.
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations),
  ## which can be used to track the provisioning process. The
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) type of
  ## the `Operation` is google.protobuf.Empty.
  ## <br>
  ## <br>The `Operation` can be polled by its `name` using
  ## GetOperation until `done` is
  ## true. When `done` is true, the `Operation` has either succeeded or failed.
  ## If the `Operation` has succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) will be
  ## set to a google.protobuf.Empty; if the `Operation` has failed, its
  ## `error` will be set to a google.rpc.Status. The `Operation` is
  ## automatically deleted after completion, so there is no need to call
  ## DeleteOperation.
  ## <br>
  ## <br>All fields listed in the [request body](#request-body) are required.
  ## <br>
  ## <br>To call `FinalizeDefaultLocation`, a member must be an Owner
  ## of the project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The resource name of the Project for which the default GCP resource
  ## location will be set, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579043 = path.getOrDefault("parent")
  valid_579043 = validateParameter(valid_579043, JString, required = true,
                                 default = nil)
  if valid_579043 != nil:
    section.add "parent", valid_579043
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
  var valid_579044 = query.getOrDefault("key")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "key", valid_579044
  var valid_579045 = query.getOrDefault("prettyPrint")
  valid_579045 = validateParameter(valid_579045, JBool, required = false,
                                 default = newJBool(true))
  if valid_579045 != nil:
    section.add "prettyPrint", valid_579045
  var valid_579046 = query.getOrDefault("oauth_token")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "oauth_token", valid_579046
  var valid_579047 = query.getOrDefault("$.xgafv")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = newJString("1"))
  if valid_579047 != nil:
    section.add "$.xgafv", valid_579047
  var valid_579048 = query.getOrDefault("alt")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = newJString("json"))
  if valid_579048 != nil:
    section.add "alt", valid_579048
  var valid_579049 = query.getOrDefault("uploadType")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "uploadType", valid_579049
  var valid_579050 = query.getOrDefault("quotaUser")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "quotaUser", valid_579050
  var valid_579051 = query.getOrDefault("callback")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "callback", valid_579051
  var valid_579052 = query.getOrDefault("fields")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "fields", valid_579052
  var valid_579053 = query.getOrDefault("access_token")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "access_token", valid_579053
  var valid_579054 = query.getOrDefault("upload_protocol")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "upload_protocol", valid_579054
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

proc call*(call_579056: Call_FirebaseProjectsDefaultLocationFinalize_579040;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the default Google Cloud Platform (GCP) resource location for the
  ## specified FirebaseProject.
  ## <br>
  ## <br>This method creates an App Engine application with a
  ## [default Cloud Storage
  ## bucket](https://cloud.google.com/appengine/docs/standard/python/googlecloudstorageclient/setting-up-cloud-storage#activating_a_cloud_storage_bucket),
  ## located in the specified
  ## [`location_id`](#body.request_body.FIELDS.location_id).
  ## This location must be one of the available
  ## [GCP resource
  ## locations](https://firebase.google.com/docs/projects/locations). <br>
  ## <br>After the default GCP resource location is finalized, or if it was
  ## already set, it cannot be changed. The default GCP resource location for
  ## the specified FirebaseProject might already be set because either the
  ## GCP `Project` already has an App Engine application or
  ## `FinalizeDefaultLocation` was previously called with a specified
  ## `location_id`. Any new calls to `FinalizeDefaultLocation` with a
  ## <em>different</em> specified `location_id` will return a 409 error.
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations),
  ## which can be used to track the provisioning process. The
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) type of
  ## the `Operation` is google.protobuf.Empty.
  ## <br>
  ## <br>The `Operation` can be polled by its `name` using
  ## GetOperation until `done` is
  ## true. When `done` is true, the `Operation` has either succeeded or failed.
  ## If the `Operation` has succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) will be
  ## set to a google.protobuf.Empty; if the `Operation` has failed, its
  ## `error` will be set to a google.rpc.Status. The `Operation` is
  ## automatically deleted after completion, so there is no need to call
  ## DeleteOperation.
  ## <br>
  ## <br>All fields listed in the [request body](#request-body) are required.
  ## <br>
  ## <br>To call `FinalizeDefaultLocation`, a member must be an Owner
  ## of the project.
  ## 
  let valid = call_579056.validator(path, query, header, formData, body)
  let scheme = call_579056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579056.url(scheme.get, call_579056.host, call_579056.base,
                         call_579056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579056, url, valid)

proc call*(call_579057: Call_FirebaseProjectsDefaultLocationFinalize_579040;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsDefaultLocationFinalize
  ## Sets the default Google Cloud Platform (GCP) resource location for the
  ## specified FirebaseProject.
  ## <br>
  ## <br>This method creates an App Engine application with a
  ## [default Cloud Storage
  ## bucket](https://cloud.google.com/appengine/docs/standard/python/googlecloudstorageclient/setting-up-cloud-storage#activating_a_cloud_storage_bucket),
  ## located in the specified
  ## [`location_id`](#body.request_body.FIELDS.location_id).
  ## This location must be one of the available
  ## [GCP resource
  ## locations](https://firebase.google.com/docs/projects/locations). <br>
  ## <br>After the default GCP resource location is finalized, or if it was
  ## already set, it cannot be changed. The default GCP resource location for
  ## the specified FirebaseProject might already be set because either the
  ## GCP `Project` already has an App Engine application or
  ## `FinalizeDefaultLocation` was previously called with a specified
  ## `location_id`. Any new calls to `FinalizeDefaultLocation` with a
  ## <em>different</em> specified `location_id` will return a 409 error.
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations),
  ## which can be used to track the provisioning process. The
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) type of
  ## the `Operation` is google.protobuf.Empty.
  ## <br>
  ## <br>The `Operation` can be polled by its `name` using
  ## GetOperation until `done` is
  ## true. When `done` is true, the `Operation` has either succeeded or failed.
  ## If the `Operation` has succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) will be
  ## set to a google.protobuf.Empty; if the `Operation` has failed, its
  ## `error` will be set to a google.rpc.Status. The `Operation` is
  ## automatically deleted after completion, so there is no need to call
  ## DeleteOperation.
  ## <br>
  ## <br>All fields listed in the [request body](#request-body) are required.
  ## <br>
  ## <br>To call `FinalizeDefaultLocation`, a member must be an Owner
  ## of the project.
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
  ##         : The resource name of the Project for which the default GCP resource
  ## location will be set, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579058 = newJObject()
  var query_579059 = newJObject()
  var body_579060 = newJObject()
  add(query_579059, "key", newJString(key))
  add(query_579059, "prettyPrint", newJBool(prettyPrint))
  add(query_579059, "oauth_token", newJString(oauthToken))
  add(query_579059, "$.xgafv", newJString(Xgafv))
  add(query_579059, "alt", newJString(alt))
  add(query_579059, "uploadType", newJString(uploadType))
  add(query_579059, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579060 = body
  add(query_579059, "callback", newJString(callback))
  add(path_579058, "parent", newJString(parent))
  add(query_579059, "fields", newJString(fields))
  add(query_579059, "access_token", newJString(accessToken))
  add(query_579059, "upload_protocol", newJString(uploadProtocol))
  result = call_579057.call(path_579058, query_579059, nil, nil, body_579060)

var firebaseProjectsDefaultLocationFinalize* = Call_FirebaseProjectsDefaultLocationFinalize_579040(
    name: "firebaseProjectsDefaultLocationFinalize", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com",
    route: "/v1beta1/{parent}/defaultLocation:finalize",
    validator: validate_FirebaseProjectsDefaultLocationFinalize_579041, base: "/",
    url: url_FirebaseProjectsDefaultLocationFinalize_579042,
    schemes: {Scheme.Https})
type
  Call_FirebaseProjectsIosAppsCreate_579082 = ref object of OpenApiRestCall_578339
proc url_FirebaseProjectsIosAppsCreate_579084(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/iosApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsIosAppsCreate_579083(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests that a new IosApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579085 = path.getOrDefault("parent")
  valid_579085 = validateParameter(valid_579085, JString, required = true,
                                 default = nil)
  if valid_579085 != nil:
    section.add "parent", valid_579085
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
  var valid_579086 = query.getOrDefault("key")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "key", valid_579086
  var valid_579087 = query.getOrDefault("prettyPrint")
  valid_579087 = validateParameter(valid_579087, JBool, required = false,
                                 default = newJBool(true))
  if valid_579087 != nil:
    section.add "prettyPrint", valid_579087
  var valid_579088 = query.getOrDefault("oauth_token")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "oauth_token", valid_579088
  var valid_579089 = query.getOrDefault("$.xgafv")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = newJString("1"))
  if valid_579089 != nil:
    section.add "$.xgafv", valid_579089
  var valid_579090 = query.getOrDefault("alt")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = newJString("json"))
  if valid_579090 != nil:
    section.add "alt", valid_579090
  var valid_579091 = query.getOrDefault("uploadType")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "uploadType", valid_579091
  var valid_579092 = query.getOrDefault("quotaUser")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "quotaUser", valid_579092
  var valid_579093 = query.getOrDefault("callback")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "callback", valid_579093
  var valid_579094 = query.getOrDefault("fields")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "fields", valid_579094
  var valid_579095 = query.getOrDefault("access_token")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "access_token", valid_579095
  var valid_579096 = query.getOrDefault("upload_protocol")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "upload_protocol", valid_579096
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

proc call*(call_579098: Call_FirebaseProjectsIosAppsCreate_579082; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a new IosApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  let valid = call_579098.validator(path, query, header, formData, body)
  let scheme = call_579098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579098.url(scheme.get, call_579098.host, call_579098.base,
                         call_579098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579098, url, valid)

proc call*(call_579099: Call_FirebaseProjectsIosAppsCreate_579082; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsIosAppsCreate
  ## Requests that a new IosApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
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
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579100 = newJObject()
  var query_579101 = newJObject()
  var body_579102 = newJObject()
  add(query_579101, "key", newJString(key))
  add(query_579101, "prettyPrint", newJBool(prettyPrint))
  add(query_579101, "oauth_token", newJString(oauthToken))
  add(query_579101, "$.xgafv", newJString(Xgafv))
  add(query_579101, "alt", newJString(alt))
  add(query_579101, "uploadType", newJString(uploadType))
  add(query_579101, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579102 = body
  add(query_579101, "callback", newJString(callback))
  add(path_579100, "parent", newJString(parent))
  add(query_579101, "fields", newJString(fields))
  add(query_579101, "access_token", newJString(accessToken))
  add(query_579101, "upload_protocol", newJString(uploadProtocol))
  result = call_579099.call(path_579100, query_579101, nil, nil, body_579102)

var firebaseProjectsIosAppsCreate* = Call_FirebaseProjectsIosAppsCreate_579082(
    name: "firebaseProjectsIosAppsCreate", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/iosApps",
    validator: validate_FirebaseProjectsIosAppsCreate_579083, base: "/",
    url: url_FirebaseProjectsIosAppsCreate_579084, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsIosAppsList_579061 = ref object of OpenApiRestCall_578339
proc url_FirebaseProjectsIosAppsList_579063(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/iosApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsIosAppsList_579062(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists each IosApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579064 = path.getOrDefault("parent")
  valid_579064 = validateParameter(valid_579064, JString, required = true,
                                 default = nil)
  if valid_579064 != nil:
    section.add "parent", valid_579064
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
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this at its discretion.
  ## If no value is specified (or too large a value is specified), the server
  ## will impose its own limit.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token returned from a previous call to `ListIosApps` indicating where in
  ## the set of Apps to resume listing.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579065 = query.getOrDefault("key")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "key", valid_579065
  var valid_579066 = query.getOrDefault("prettyPrint")
  valid_579066 = validateParameter(valid_579066, JBool, required = false,
                                 default = newJBool(true))
  if valid_579066 != nil:
    section.add "prettyPrint", valid_579066
  var valid_579067 = query.getOrDefault("oauth_token")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "oauth_token", valid_579067
  var valid_579068 = query.getOrDefault("$.xgafv")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = newJString("1"))
  if valid_579068 != nil:
    section.add "$.xgafv", valid_579068
  var valid_579069 = query.getOrDefault("pageSize")
  valid_579069 = validateParameter(valid_579069, JInt, required = false, default = nil)
  if valid_579069 != nil:
    section.add "pageSize", valid_579069
  var valid_579070 = query.getOrDefault("alt")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = newJString("json"))
  if valid_579070 != nil:
    section.add "alt", valid_579070
  var valid_579071 = query.getOrDefault("uploadType")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "uploadType", valid_579071
  var valid_579072 = query.getOrDefault("quotaUser")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "quotaUser", valid_579072
  var valid_579073 = query.getOrDefault("pageToken")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "pageToken", valid_579073
  var valid_579074 = query.getOrDefault("callback")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "callback", valid_579074
  var valid_579075 = query.getOrDefault("fields")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "fields", valid_579075
  var valid_579076 = query.getOrDefault("access_token")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "access_token", valid_579076
  var valid_579077 = query.getOrDefault("upload_protocol")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "upload_protocol", valid_579077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579078: Call_FirebaseProjectsIosAppsList_579061; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists each IosApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  let valid = call_579078.validator(path, query, header, formData, body)
  let scheme = call_579078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579078.url(scheme.get, call_579078.host, call_579078.base,
                         call_579078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579078, url, valid)

proc call*(call_579079: Call_FirebaseProjectsIosAppsList_579061; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsIosAppsList
  ## Lists each IosApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this at its discretion.
  ## If no value is specified (or too large a value is specified), the server
  ## will impose its own limit.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Token returned from a previous call to `ListIosApps` indicating where in
  ## the set of Apps to resume listing.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579080 = newJObject()
  var query_579081 = newJObject()
  add(query_579081, "key", newJString(key))
  add(query_579081, "prettyPrint", newJBool(prettyPrint))
  add(query_579081, "oauth_token", newJString(oauthToken))
  add(query_579081, "$.xgafv", newJString(Xgafv))
  add(query_579081, "pageSize", newJInt(pageSize))
  add(query_579081, "alt", newJString(alt))
  add(query_579081, "uploadType", newJString(uploadType))
  add(query_579081, "quotaUser", newJString(quotaUser))
  add(query_579081, "pageToken", newJString(pageToken))
  add(query_579081, "callback", newJString(callback))
  add(path_579080, "parent", newJString(parent))
  add(query_579081, "fields", newJString(fields))
  add(query_579081, "access_token", newJString(accessToken))
  add(query_579081, "upload_protocol", newJString(uploadProtocol))
  result = call_579079.call(path_579080, query_579081, nil, nil, nil)

var firebaseProjectsIosAppsList* = Call_FirebaseProjectsIosAppsList_579061(
    name: "firebaseProjectsIosAppsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/iosApps",
    validator: validate_FirebaseProjectsIosAppsList_579062, base: "/",
    url: url_FirebaseProjectsIosAppsList_579063, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsShaCreate_579122 = ref object of OpenApiRestCall_578339
proc url_FirebaseProjectsAndroidAppsShaCreate_579124(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/sha")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsAndroidAppsShaCreate_579123(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a SHA certificate to the specified AndroidApp.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent App to which a SHA certificate will be added, in the format:
  ## <br><code>projects/<var>projectId</var>/androidApps/<var>appId</var></code>
  ## <br>As an <var>appId</var> is a unique identifier, the Unique Resource
  ## from Sub-Collection access pattern may be used here, in the format:
  ## <br><code>projects/-/androidApps/<var>appId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579125 = path.getOrDefault("parent")
  valid_579125 = validateParameter(valid_579125, JString, required = true,
                                 default = nil)
  if valid_579125 != nil:
    section.add "parent", valid_579125
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
  var valid_579126 = query.getOrDefault("key")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "key", valid_579126
  var valid_579127 = query.getOrDefault("prettyPrint")
  valid_579127 = validateParameter(valid_579127, JBool, required = false,
                                 default = newJBool(true))
  if valid_579127 != nil:
    section.add "prettyPrint", valid_579127
  var valid_579128 = query.getOrDefault("oauth_token")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "oauth_token", valid_579128
  var valid_579129 = query.getOrDefault("$.xgafv")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = newJString("1"))
  if valid_579129 != nil:
    section.add "$.xgafv", valid_579129
  var valid_579130 = query.getOrDefault("alt")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = newJString("json"))
  if valid_579130 != nil:
    section.add "alt", valid_579130
  var valid_579131 = query.getOrDefault("uploadType")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "uploadType", valid_579131
  var valid_579132 = query.getOrDefault("quotaUser")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "quotaUser", valid_579132
  var valid_579133 = query.getOrDefault("callback")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "callback", valid_579133
  var valid_579134 = query.getOrDefault("fields")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "fields", valid_579134
  var valid_579135 = query.getOrDefault("access_token")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "access_token", valid_579135
  var valid_579136 = query.getOrDefault("upload_protocol")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "upload_protocol", valid_579136
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

proc call*(call_579138: Call_FirebaseProjectsAndroidAppsShaCreate_579122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a SHA certificate to the specified AndroidApp.
  ## 
  let valid = call_579138.validator(path, query, header, formData, body)
  let scheme = call_579138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579138.url(scheme.get, call_579138.host, call_579138.base,
                         call_579138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579138, url, valid)

proc call*(call_579139: Call_FirebaseProjectsAndroidAppsShaCreate_579122;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsAndroidAppsShaCreate
  ## Adds a SHA certificate to the specified AndroidApp.
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
  ##         : The parent App to which a SHA certificate will be added, in the format:
  ## <br><code>projects/<var>projectId</var>/androidApps/<var>appId</var></code>
  ## <br>As an <var>appId</var> is a unique identifier, the Unique Resource
  ## from Sub-Collection access pattern may be used here, in the format:
  ## <br><code>projects/-/androidApps/<var>appId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579140 = newJObject()
  var query_579141 = newJObject()
  var body_579142 = newJObject()
  add(query_579141, "key", newJString(key))
  add(query_579141, "prettyPrint", newJBool(prettyPrint))
  add(query_579141, "oauth_token", newJString(oauthToken))
  add(query_579141, "$.xgafv", newJString(Xgafv))
  add(query_579141, "alt", newJString(alt))
  add(query_579141, "uploadType", newJString(uploadType))
  add(query_579141, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579142 = body
  add(query_579141, "callback", newJString(callback))
  add(path_579140, "parent", newJString(parent))
  add(query_579141, "fields", newJString(fields))
  add(query_579141, "access_token", newJString(accessToken))
  add(query_579141, "upload_protocol", newJString(uploadProtocol))
  result = call_579139.call(path_579140, query_579141, nil, nil, body_579142)

var firebaseProjectsAndroidAppsShaCreate* = Call_FirebaseProjectsAndroidAppsShaCreate_579122(
    name: "firebaseProjectsAndroidAppsShaCreate", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/sha",
    validator: validate_FirebaseProjectsAndroidAppsShaCreate_579123, base: "/",
    url: url_FirebaseProjectsAndroidAppsShaCreate_579124, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsShaList_579103 = ref object of OpenApiRestCall_578339
proc url_FirebaseProjectsAndroidAppsShaList_579105(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/sha")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsAndroidAppsShaList_579104(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of SHA-1 and SHA-256 certificates for the specified
  ## AndroidApp.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent App for which to list SHA certificates, in the format:
  ## <br><code>projects/<var>projectId</var>/androidApps/<var>appId</var></code>
  ## <br>As an <var>appId</var> is a unique identifier, the Unique Resource
  ## from Sub-Collection access pattern may be used here, in the format:
  ## <br><code>projects/-/androidApps/<var>appId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579106 = path.getOrDefault("parent")
  valid_579106 = validateParameter(valid_579106, JString, required = true,
                                 default = nil)
  if valid_579106 != nil:
    section.add "parent", valid_579106
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
  var valid_579107 = query.getOrDefault("key")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "key", valid_579107
  var valid_579108 = query.getOrDefault("prettyPrint")
  valid_579108 = validateParameter(valid_579108, JBool, required = false,
                                 default = newJBool(true))
  if valid_579108 != nil:
    section.add "prettyPrint", valid_579108
  var valid_579109 = query.getOrDefault("oauth_token")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "oauth_token", valid_579109
  var valid_579110 = query.getOrDefault("$.xgafv")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = newJString("1"))
  if valid_579110 != nil:
    section.add "$.xgafv", valid_579110
  var valid_579111 = query.getOrDefault("alt")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = newJString("json"))
  if valid_579111 != nil:
    section.add "alt", valid_579111
  var valid_579112 = query.getOrDefault("uploadType")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "uploadType", valid_579112
  var valid_579113 = query.getOrDefault("quotaUser")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "quotaUser", valid_579113
  var valid_579114 = query.getOrDefault("callback")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "callback", valid_579114
  var valid_579115 = query.getOrDefault("fields")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "fields", valid_579115
  var valid_579116 = query.getOrDefault("access_token")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "access_token", valid_579116
  var valid_579117 = query.getOrDefault("upload_protocol")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "upload_protocol", valid_579117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579118: Call_FirebaseProjectsAndroidAppsShaList_579103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the list of SHA-1 and SHA-256 certificates for the specified
  ## AndroidApp.
  ## 
  let valid = call_579118.validator(path, query, header, formData, body)
  let scheme = call_579118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579118.url(scheme.get, call_579118.host, call_579118.base,
                         call_579118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579118, url, valid)

proc call*(call_579119: Call_FirebaseProjectsAndroidAppsShaList_579103;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsAndroidAppsShaList
  ## Returns the list of SHA-1 and SHA-256 certificates for the specified
  ## AndroidApp.
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
  ##   parent: string (required)
  ##         : The parent App for which to list SHA certificates, in the format:
  ## <br><code>projects/<var>projectId</var>/androidApps/<var>appId</var></code>
  ## <br>As an <var>appId</var> is a unique identifier, the Unique Resource
  ## from Sub-Collection access pattern may be used here, in the format:
  ## <br><code>projects/-/androidApps/<var>appId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579120 = newJObject()
  var query_579121 = newJObject()
  add(query_579121, "key", newJString(key))
  add(query_579121, "prettyPrint", newJBool(prettyPrint))
  add(query_579121, "oauth_token", newJString(oauthToken))
  add(query_579121, "$.xgafv", newJString(Xgafv))
  add(query_579121, "alt", newJString(alt))
  add(query_579121, "uploadType", newJString(uploadType))
  add(query_579121, "quotaUser", newJString(quotaUser))
  add(query_579121, "callback", newJString(callback))
  add(path_579120, "parent", newJString(parent))
  add(query_579121, "fields", newJString(fields))
  add(query_579121, "access_token", newJString(accessToken))
  add(query_579121, "upload_protocol", newJString(uploadProtocol))
  result = call_579119.call(path_579120, query_579121, nil, nil, nil)

var firebaseProjectsAndroidAppsShaList* = Call_FirebaseProjectsAndroidAppsShaList_579103(
    name: "firebaseProjectsAndroidAppsShaList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/sha",
    validator: validate_FirebaseProjectsAndroidAppsShaList_579104, base: "/",
    url: url_FirebaseProjectsAndroidAppsShaList_579105, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsWebAppsCreate_579164 = ref object of OpenApiRestCall_578339
proc url_FirebaseProjectsWebAppsCreate_579166(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/webApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsWebAppsCreate_579165(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests that a new WebApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579167 = path.getOrDefault("parent")
  valid_579167 = validateParameter(valid_579167, JString, required = true,
                                 default = nil)
  if valid_579167 != nil:
    section.add "parent", valid_579167
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
  var valid_579168 = query.getOrDefault("key")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "key", valid_579168
  var valid_579169 = query.getOrDefault("prettyPrint")
  valid_579169 = validateParameter(valid_579169, JBool, required = false,
                                 default = newJBool(true))
  if valid_579169 != nil:
    section.add "prettyPrint", valid_579169
  var valid_579170 = query.getOrDefault("oauth_token")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "oauth_token", valid_579170
  var valid_579171 = query.getOrDefault("$.xgafv")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = newJString("1"))
  if valid_579171 != nil:
    section.add "$.xgafv", valid_579171
  var valid_579172 = query.getOrDefault("alt")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = newJString("json"))
  if valid_579172 != nil:
    section.add "alt", valid_579172
  var valid_579173 = query.getOrDefault("uploadType")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "uploadType", valid_579173
  var valid_579174 = query.getOrDefault("quotaUser")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "quotaUser", valid_579174
  var valid_579175 = query.getOrDefault("callback")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "callback", valid_579175
  var valid_579176 = query.getOrDefault("fields")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "fields", valid_579176
  var valid_579177 = query.getOrDefault("access_token")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "access_token", valid_579177
  var valid_579178 = query.getOrDefault("upload_protocol")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "upload_protocol", valid_579178
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

proc call*(call_579180: Call_FirebaseProjectsWebAppsCreate_579164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a new WebApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  let valid = call_579180.validator(path, query, header, formData, body)
  let scheme = call_579180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579180.url(scheme.get, call_579180.host, call_579180.base,
                         call_579180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579180, url, valid)

proc call*(call_579181: Call_FirebaseProjectsWebAppsCreate_579164; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsWebAppsCreate
  ## Requests that a new WebApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
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
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579182 = newJObject()
  var query_579183 = newJObject()
  var body_579184 = newJObject()
  add(query_579183, "key", newJString(key))
  add(query_579183, "prettyPrint", newJBool(prettyPrint))
  add(query_579183, "oauth_token", newJString(oauthToken))
  add(query_579183, "$.xgafv", newJString(Xgafv))
  add(query_579183, "alt", newJString(alt))
  add(query_579183, "uploadType", newJString(uploadType))
  add(query_579183, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579184 = body
  add(query_579183, "callback", newJString(callback))
  add(path_579182, "parent", newJString(parent))
  add(query_579183, "fields", newJString(fields))
  add(query_579183, "access_token", newJString(accessToken))
  add(query_579183, "upload_protocol", newJString(uploadProtocol))
  result = call_579181.call(path_579182, query_579183, nil, nil, body_579184)

var firebaseProjectsWebAppsCreate* = Call_FirebaseProjectsWebAppsCreate_579164(
    name: "firebaseProjectsWebAppsCreate", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/webApps",
    validator: validate_FirebaseProjectsWebAppsCreate_579165, base: "/",
    url: url_FirebaseProjectsWebAppsCreate_579166, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsWebAppsList_579143 = ref object of OpenApiRestCall_578339
proc url_FirebaseProjectsWebAppsList_579145(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/webApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsWebAppsList_579144(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists each WebApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579146 = path.getOrDefault("parent")
  valid_579146 = validateParameter(valid_579146, JString, required = true,
                                 default = nil)
  if valid_579146 != nil:
    section.add "parent", valid_579146
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
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token returned from a previous call to `ListWebApps` indicating where in
  ## the set of Apps to resume listing.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579147 = query.getOrDefault("key")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "key", valid_579147
  var valid_579148 = query.getOrDefault("prettyPrint")
  valid_579148 = validateParameter(valid_579148, JBool, required = false,
                                 default = newJBool(true))
  if valid_579148 != nil:
    section.add "prettyPrint", valid_579148
  var valid_579149 = query.getOrDefault("oauth_token")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "oauth_token", valid_579149
  var valid_579150 = query.getOrDefault("$.xgafv")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = newJString("1"))
  if valid_579150 != nil:
    section.add "$.xgafv", valid_579150
  var valid_579151 = query.getOrDefault("pageSize")
  valid_579151 = validateParameter(valid_579151, JInt, required = false, default = nil)
  if valid_579151 != nil:
    section.add "pageSize", valid_579151
  var valid_579152 = query.getOrDefault("alt")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = newJString("json"))
  if valid_579152 != nil:
    section.add "alt", valid_579152
  var valid_579153 = query.getOrDefault("uploadType")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "uploadType", valid_579153
  var valid_579154 = query.getOrDefault("quotaUser")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "quotaUser", valid_579154
  var valid_579155 = query.getOrDefault("pageToken")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "pageToken", valid_579155
  var valid_579156 = query.getOrDefault("callback")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "callback", valid_579156
  var valid_579157 = query.getOrDefault("fields")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "fields", valid_579157
  var valid_579158 = query.getOrDefault("access_token")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "access_token", valid_579158
  var valid_579159 = query.getOrDefault("upload_protocol")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "upload_protocol", valid_579159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579160: Call_FirebaseProjectsWebAppsList_579143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists each WebApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  let valid = call_579160.validator(path, query, header, formData, body)
  let scheme = call_579160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579160.url(scheme.get, call_579160.host, call_579160.base,
                         call_579160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579160, url, valid)

proc call*(call_579161: Call_FirebaseProjectsWebAppsList_579143; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsWebAppsList
  ## Lists each WebApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Token returned from a previous call to `ListWebApps` indicating where in
  ## the set of Apps to resume listing.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579162 = newJObject()
  var query_579163 = newJObject()
  add(query_579163, "key", newJString(key))
  add(query_579163, "prettyPrint", newJBool(prettyPrint))
  add(query_579163, "oauth_token", newJString(oauthToken))
  add(query_579163, "$.xgafv", newJString(Xgafv))
  add(query_579163, "pageSize", newJInt(pageSize))
  add(query_579163, "alt", newJString(alt))
  add(query_579163, "uploadType", newJString(uploadType))
  add(query_579163, "quotaUser", newJString(quotaUser))
  add(query_579163, "pageToken", newJString(pageToken))
  add(query_579163, "callback", newJString(callback))
  add(path_579162, "parent", newJString(parent))
  add(query_579163, "fields", newJString(fields))
  add(query_579163, "access_token", newJString(accessToken))
  add(query_579163, "upload_protocol", newJString(uploadProtocol))
  result = call_579161.call(path_579162, query_579163, nil, nil, nil)

var firebaseProjectsWebAppsList* = Call_FirebaseProjectsWebAppsList_579143(
    name: "firebaseProjectsWebAppsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/webApps",
    validator: validate_FirebaseProjectsWebAppsList_579144, base: "/",
    url: url_FirebaseProjectsWebAppsList_579145, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAddGoogleAnalytics_579185 = ref object of OpenApiRestCall_578339
proc url_FirebaseProjectsAddGoogleAnalytics_579187(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":addGoogleAnalytics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsAddGoogleAnalytics_579186(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Links a FirebaseProject with an existing
  ## [Google Analytics account](http://www.google.com/analytics/).
  ## <br>
  ## <br>Using this call, you can either:
  ## <ul>
  ## <li>Specify an `analyticsAccountId` to provision a new Google Analytics
  ## property within the specified account and associate the new property with
  ## your `FirebaseProject`.</li>
  ## <li>Specify an existing `analyticsPropertyId` to associate the property
  ## with your `FirebaseProject`.</li>
  ## </ul>
  ## <br>
  ## Note that when you call `AddGoogleAnalytics`:
  ## <ol>
  ## <li>The first check determines if any existing data streams in the
  ## Google Analytics property correspond to any existing Firebase Apps in your
  ## `FirebaseProject` (based on the `packageName` or `bundleId` associated with
  ## the data stream). Then, as applicable, the data streams and apps are
  ## linked. Note that this auto-linking only applies to Android Apps and iOS
  ## Apps.</li>
  ## <li>If no corresponding data streams are found for your Firebase Apps,
  ## new data streams are provisioned in the Google Analytics property
  ## for each of your Firebase Apps. Note that a new data stream is always
  ## provisioned for a Web App even if it was previously associated with a
  ## data stream in your Analytics property.</li>
  ## </ol>
  ## Learn more about the hierarchy and structure of Google Analytics
  ## accounts in the
  ## [Analytics
  ## documentation](https://support.google.com/analytics/answer/9303323).
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations).
  ## Poll the `Operation` to track the provisioning process by calling
  ## GetOperation until
  ## [`done`](../../v1beta1/operations#Operation.FIELDS.done) is `true`. When
  ## `done` is `true`, the `Operation` has either succeeded or failed. If the
  ## `Operation` succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) is set to
  ## an AnalyticsDetails; if the `Operation` failed, its
  ## [`error`](../../v1beta1/operations#Operation.FIELDS.error) is set to a
  ## google.rpc.Status.
  ## <br>
  ## <br>To call `AddGoogleAnalytics`, a member must be an Owner for
  ## the existing `FirebaseProject` and have the
  ## [`Edit` permission](https://support.google.com/analytics/answer/2884495)
  ## for the Google Analytics account.
  ## <br>
  ## <br>If a `FirebaseProject` already has Google Analytics enabled, and you
  ## call `AddGoogleAnalytics` using an `analyticsPropertyId` that's different
  ## from the currently associated property, then the call will fail. Analytics
  ## may have already been enabled in the Firebase console or by specifying
  ## `timeZone` and `regionCode` in the call to
  ## [`AddFirebase`](../../v1beta1/projects/addFirebase).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent `FirebaseProject` to link to an existing Google Analytics
  ## account, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579188 = path.getOrDefault("parent")
  valid_579188 = validateParameter(valid_579188, JString, required = true,
                                 default = nil)
  if valid_579188 != nil:
    section.add "parent", valid_579188
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
  var valid_579189 = query.getOrDefault("key")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "key", valid_579189
  var valid_579190 = query.getOrDefault("prettyPrint")
  valid_579190 = validateParameter(valid_579190, JBool, required = false,
                                 default = newJBool(true))
  if valid_579190 != nil:
    section.add "prettyPrint", valid_579190
  var valid_579191 = query.getOrDefault("oauth_token")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "oauth_token", valid_579191
  var valid_579192 = query.getOrDefault("$.xgafv")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = newJString("1"))
  if valid_579192 != nil:
    section.add "$.xgafv", valid_579192
  var valid_579193 = query.getOrDefault("alt")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = newJString("json"))
  if valid_579193 != nil:
    section.add "alt", valid_579193
  var valid_579194 = query.getOrDefault("uploadType")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "uploadType", valid_579194
  var valid_579195 = query.getOrDefault("quotaUser")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "quotaUser", valid_579195
  var valid_579196 = query.getOrDefault("callback")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "callback", valid_579196
  var valid_579197 = query.getOrDefault("fields")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "fields", valid_579197
  var valid_579198 = query.getOrDefault("access_token")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "access_token", valid_579198
  var valid_579199 = query.getOrDefault("upload_protocol")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "upload_protocol", valid_579199
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

proc call*(call_579201: Call_FirebaseProjectsAddGoogleAnalytics_579185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Links a FirebaseProject with an existing
  ## [Google Analytics account](http://www.google.com/analytics/).
  ## <br>
  ## <br>Using this call, you can either:
  ## <ul>
  ## <li>Specify an `analyticsAccountId` to provision a new Google Analytics
  ## property within the specified account and associate the new property with
  ## your `FirebaseProject`.</li>
  ## <li>Specify an existing `analyticsPropertyId` to associate the property
  ## with your `FirebaseProject`.</li>
  ## </ul>
  ## <br>
  ## Note that when you call `AddGoogleAnalytics`:
  ## <ol>
  ## <li>The first check determines if any existing data streams in the
  ## Google Analytics property correspond to any existing Firebase Apps in your
  ## `FirebaseProject` (based on the `packageName` or `bundleId` associated with
  ## the data stream). Then, as applicable, the data streams and apps are
  ## linked. Note that this auto-linking only applies to Android Apps and iOS
  ## Apps.</li>
  ## <li>If no corresponding data streams are found for your Firebase Apps,
  ## new data streams are provisioned in the Google Analytics property
  ## for each of your Firebase Apps. Note that a new data stream is always
  ## provisioned for a Web App even if it was previously associated with a
  ## data stream in your Analytics property.</li>
  ## </ol>
  ## Learn more about the hierarchy and structure of Google Analytics
  ## accounts in the
  ## [Analytics
  ## documentation](https://support.google.com/analytics/answer/9303323).
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations).
  ## Poll the `Operation` to track the provisioning process by calling
  ## GetOperation until
  ## [`done`](../../v1beta1/operations#Operation.FIELDS.done) is `true`. When
  ## `done` is `true`, the `Operation` has either succeeded or failed. If the
  ## `Operation` succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) is set to
  ## an AnalyticsDetails; if the `Operation` failed, its
  ## [`error`](../../v1beta1/operations#Operation.FIELDS.error) is set to a
  ## google.rpc.Status.
  ## <br>
  ## <br>To call `AddGoogleAnalytics`, a member must be an Owner for
  ## the existing `FirebaseProject` and have the
  ## [`Edit` permission](https://support.google.com/analytics/answer/2884495)
  ## for the Google Analytics account.
  ## <br>
  ## <br>If a `FirebaseProject` already has Google Analytics enabled, and you
  ## call `AddGoogleAnalytics` using an `analyticsPropertyId` that's different
  ## from the currently associated property, then the call will fail. Analytics
  ## may have already been enabled in the Firebase console or by specifying
  ## `timeZone` and `regionCode` in the call to
  ## [`AddFirebase`](../../v1beta1/projects/addFirebase).
  ## 
  let valid = call_579201.validator(path, query, header, formData, body)
  let scheme = call_579201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579201.url(scheme.get, call_579201.host, call_579201.base,
                         call_579201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579201, url, valid)

proc call*(call_579202: Call_FirebaseProjectsAddGoogleAnalytics_579185;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsAddGoogleAnalytics
  ## Links a FirebaseProject with an existing
  ## [Google Analytics account](http://www.google.com/analytics/).
  ## <br>
  ## <br>Using this call, you can either:
  ## <ul>
  ## <li>Specify an `analyticsAccountId` to provision a new Google Analytics
  ## property within the specified account and associate the new property with
  ## your `FirebaseProject`.</li>
  ## <li>Specify an existing `analyticsPropertyId` to associate the property
  ## with your `FirebaseProject`.</li>
  ## </ul>
  ## <br>
  ## Note that when you call `AddGoogleAnalytics`:
  ## <ol>
  ## <li>The first check determines if any existing data streams in the
  ## Google Analytics property correspond to any existing Firebase Apps in your
  ## `FirebaseProject` (based on the `packageName` or `bundleId` associated with
  ## the data stream). Then, as applicable, the data streams and apps are
  ## linked. Note that this auto-linking only applies to Android Apps and iOS
  ## Apps.</li>
  ## <li>If no corresponding data streams are found for your Firebase Apps,
  ## new data streams are provisioned in the Google Analytics property
  ## for each of your Firebase Apps. Note that a new data stream is always
  ## provisioned for a Web App even if it was previously associated with a
  ## data stream in your Analytics property.</li>
  ## </ol>
  ## Learn more about the hierarchy and structure of Google Analytics
  ## accounts in the
  ## [Analytics
  ## documentation](https://support.google.com/analytics/answer/9303323).
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations).
  ## Poll the `Operation` to track the provisioning process by calling
  ## GetOperation until
  ## [`done`](../../v1beta1/operations#Operation.FIELDS.done) is `true`. When
  ## `done` is `true`, the `Operation` has either succeeded or failed. If the
  ## `Operation` succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) is set to
  ## an AnalyticsDetails; if the `Operation` failed, its
  ## [`error`](../../v1beta1/operations#Operation.FIELDS.error) is set to a
  ## google.rpc.Status.
  ## <br>
  ## <br>To call `AddGoogleAnalytics`, a member must be an Owner for
  ## the existing `FirebaseProject` and have the
  ## [`Edit` permission](https://support.google.com/analytics/answer/2884495)
  ## for the Google Analytics account.
  ## <br>
  ## <br>If a `FirebaseProject` already has Google Analytics enabled, and you
  ## call `AddGoogleAnalytics` using an `analyticsPropertyId` that's different
  ## from the currently associated property, then the call will fail. Analytics
  ## may have already been enabled in the Firebase console or by specifying
  ## `timeZone` and `regionCode` in the call to
  ## [`AddFirebase`](../../v1beta1/projects/addFirebase).
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
  ##         : The parent `FirebaseProject` to link to an existing Google Analytics
  ## account, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579203 = newJObject()
  var query_579204 = newJObject()
  var body_579205 = newJObject()
  add(query_579204, "key", newJString(key))
  add(query_579204, "prettyPrint", newJBool(prettyPrint))
  add(query_579204, "oauth_token", newJString(oauthToken))
  add(query_579204, "$.xgafv", newJString(Xgafv))
  add(query_579204, "alt", newJString(alt))
  add(query_579204, "uploadType", newJString(uploadType))
  add(query_579204, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579205 = body
  add(query_579204, "callback", newJString(callback))
  add(path_579203, "parent", newJString(parent))
  add(query_579204, "fields", newJString(fields))
  add(query_579204, "access_token", newJString(accessToken))
  add(query_579204, "upload_protocol", newJString(uploadProtocol))
  result = call_579202.call(path_579203, query_579204, nil, nil, body_579205)

var firebaseProjectsAddGoogleAnalytics* = Call_FirebaseProjectsAddGoogleAnalytics_579185(
    name: "firebaseProjectsAddGoogleAnalytics", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com",
    route: "/v1beta1/{parent}:addGoogleAnalytics",
    validator: validate_FirebaseProjectsAddGoogleAnalytics_579186, base: "/",
    url: url_FirebaseProjectsAddGoogleAnalytics_579187, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsRemoveAnalytics_579206 = ref object of OpenApiRestCall_578339
proc url_FirebaseProjectsRemoveAnalytics_579208(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":removeAnalytics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsRemoveAnalytics_579207(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unlinks the specified `FirebaseProject` from its Google Analytics account.
  ## <br>
  ## <br>This call removes the association of the specified `FirebaseProject`
  ## with its current Google Analytics property. However, this call does not
  ## delete the Google Analytics resources, such as the Google Analytics
  ## property or any data streams.
  ## <br>
  ## <br>These resources may be re-associated later to the `FirebaseProject` by
  ## calling
  ## [`AddGoogleAnalytics`](../../v1beta1/projects/addGoogleAnalytics) and
  ## specifying the same `analyticsPropertyId`. For Android Apps and iOS Apps,
  ## this call re-links data streams with their corresponding apps. However,
  ## for Web Apps, this call provisions a <em>new</em> data stream for each Web
  ## App.
  ## <br>
  ## <br>To call `RemoveAnalytics`, a member must be an Owner for
  ## the `FirebaseProject`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent `FirebaseProject` to unlink from its Google Analytics account,
  ## in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579209 = path.getOrDefault("parent")
  valid_579209 = validateParameter(valid_579209, JString, required = true,
                                 default = nil)
  if valid_579209 != nil:
    section.add "parent", valid_579209
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
  var valid_579210 = query.getOrDefault("key")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "key", valid_579210
  var valid_579211 = query.getOrDefault("prettyPrint")
  valid_579211 = validateParameter(valid_579211, JBool, required = false,
                                 default = newJBool(true))
  if valid_579211 != nil:
    section.add "prettyPrint", valid_579211
  var valid_579212 = query.getOrDefault("oauth_token")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "oauth_token", valid_579212
  var valid_579213 = query.getOrDefault("$.xgafv")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = newJString("1"))
  if valid_579213 != nil:
    section.add "$.xgafv", valid_579213
  var valid_579214 = query.getOrDefault("alt")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = newJString("json"))
  if valid_579214 != nil:
    section.add "alt", valid_579214
  var valid_579215 = query.getOrDefault("uploadType")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "uploadType", valid_579215
  var valid_579216 = query.getOrDefault("quotaUser")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "quotaUser", valid_579216
  var valid_579217 = query.getOrDefault("callback")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "callback", valid_579217
  var valid_579218 = query.getOrDefault("fields")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "fields", valid_579218
  var valid_579219 = query.getOrDefault("access_token")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "access_token", valid_579219
  var valid_579220 = query.getOrDefault("upload_protocol")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "upload_protocol", valid_579220
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

proc call*(call_579222: Call_FirebaseProjectsRemoveAnalytics_579206;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unlinks the specified `FirebaseProject` from its Google Analytics account.
  ## <br>
  ## <br>This call removes the association of the specified `FirebaseProject`
  ## with its current Google Analytics property. However, this call does not
  ## delete the Google Analytics resources, such as the Google Analytics
  ## property or any data streams.
  ## <br>
  ## <br>These resources may be re-associated later to the `FirebaseProject` by
  ## calling
  ## [`AddGoogleAnalytics`](../../v1beta1/projects/addGoogleAnalytics) and
  ## specifying the same `analyticsPropertyId`. For Android Apps and iOS Apps,
  ## this call re-links data streams with their corresponding apps. However,
  ## for Web Apps, this call provisions a <em>new</em> data stream for each Web
  ## App.
  ## <br>
  ## <br>To call `RemoveAnalytics`, a member must be an Owner for
  ## the `FirebaseProject`.
  ## 
  let valid = call_579222.validator(path, query, header, formData, body)
  let scheme = call_579222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579222.url(scheme.get, call_579222.host, call_579222.base,
                         call_579222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579222, url, valid)

proc call*(call_579223: Call_FirebaseProjectsRemoveAnalytics_579206;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsRemoveAnalytics
  ## Unlinks the specified `FirebaseProject` from its Google Analytics account.
  ## <br>
  ## <br>This call removes the association of the specified `FirebaseProject`
  ## with its current Google Analytics property. However, this call does not
  ## delete the Google Analytics resources, such as the Google Analytics
  ## property or any data streams.
  ## <br>
  ## <br>These resources may be re-associated later to the `FirebaseProject` by
  ## calling
  ## [`AddGoogleAnalytics`](../../v1beta1/projects/addGoogleAnalytics) and
  ## specifying the same `analyticsPropertyId`. For Android Apps and iOS Apps,
  ## this call re-links data streams with their corresponding apps. However,
  ## for Web Apps, this call provisions a <em>new</em> data stream for each Web
  ## App.
  ## <br>
  ## <br>To call `RemoveAnalytics`, a member must be an Owner for
  ## the `FirebaseProject`.
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
  ##         : The parent `FirebaseProject` to unlink from its Google Analytics account,
  ## in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579224 = newJObject()
  var query_579225 = newJObject()
  var body_579226 = newJObject()
  add(query_579225, "key", newJString(key))
  add(query_579225, "prettyPrint", newJBool(prettyPrint))
  add(query_579225, "oauth_token", newJString(oauthToken))
  add(query_579225, "$.xgafv", newJString(Xgafv))
  add(query_579225, "alt", newJString(alt))
  add(query_579225, "uploadType", newJString(uploadType))
  add(query_579225, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579226 = body
  add(query_579225, "callback", newJString(callback))
  add(path_579224, "parent", newJString(parent))
  add(query_579225, "fields", newJString(fields))
  add(query_579225, "access_token", newJString(accessToken))
  add(query_579225, "upload_protocol", newJString(uploadProtocol))
  result = call_579223.call(path_579224, query_579225, nil, nil, body_579226)

var firebaseProjectsRemoveAnalytics* = Call_FirebaseProjectsRemoveAnalytics_579206(
    name: "firebaseProjectsRemoveAnalytics", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}:removeAnalytics",
    validator: validate_FirebaseProjectsRemoveAnalytics_579207, base: "/",
    url: url_FirebaseProjectsRemoveAnalytics_579208, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsSearchApps_579227 = ref object of OpenApiRestCall_578339
proc url_FirebaseProjectsSearchApps_579229(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":searchApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsSearchApps_579228(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## A convenience method that lists all available Apps for the specified
  ## FirebaseProject.
  ## <br>
  ## <br>Typically, interaction with an App should be done using the
  ## platform-specific service, but some tool use-cases require a summary of all
  ## known Apps (such as for App selector interfaces).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579230 = path.getOrDefault("parent")
  valid_579230 = validateParameter(valid_579230, JString, required = true,
                                 default = nil)
  if valid_579230 != nil:
    section.add "parent", valid_579230
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
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token returned from a previous call to `SearchFirebaseApps` indicating
  ## where in the set of Apps to resume listing.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579231 = query.getOrDefault("key")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "key", valid_579231
  var valid_579232 = query.getOrDefault("prettyPrint")
  valid_579232 = validateParameter(valid_579232, JBool, required = false,
                                 default = newJBool(true))
  if valid_579232 != nil:
    section.add "prettyPrint", valid_579232
  var valid_579233 = query.getOrDefault("oauth_token")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "oauth_token", valid_579233
  var valid_579234 = query.getOrDefault("$.xgafv")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = newJString("1"))
  if valid_579234 != nil:
    section.add "$.xgafv", valid_579234
  var valid_579235 = query.getOrDefault("pageSize")
  valid_579235 = validateParameter(valid_579235, JInt, required = false, default = nil)
  if valid_579235 != nil:
    section.add "pageSize", valid_579235
  var valid_579236 = query.getOrDefault("alt")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = newJString("json"))
  if valid_579236 != nil:
    section.add "alt", valid_579236
  var valid_579237 = query.getOrDefault("uploadType")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "uploadType", valid_579237
  var valid_579238 = query.getOrDefault("quotaUser")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "quotaUser", valid_579238
  var valid_579239 = query.getOrDefault("pageToken")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "pageToken", valid_579239
  var valid_579240 = query.getOrDefault("callback")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "callback", valid_579240
  var valid_579241 = query.getOrDefault("fields")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "fields", valid_579241
  var valid_579242 = query.getOrDefault("access_token")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "access_token", valid_579242
  var valid_579243 = query.getOrDefault("upload_protocol")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "upload_protocol", valid_579243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579244: Call_FirebaseProjectsSearchApps_579227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## A convenience method that lists all available Apps for the specified
  ## FirebaseProject.
  ## <br>
  ## <br>Typically, interaction with an App should be done using the
  ## platform-specific service, but some tool use-cases require a summary of all
  ## known Apps (such as for App selector interfaces).
  ## 
  let valid = call_579244.validator(path, query, header, formData, body)
  let scheme = call_579244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579244.url(scheme.get, call_579244.host, call_579244.base,
                         call_579244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579244, url, valid)

proc call*(call_579245: Call_FirebaseProjectsSearchApps_579227; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsSearchApps
  ## A convenience method that lists all available Apps for the specified
  ## FirebaseProject.
  ## <br>
  ## <br>Typically, interaction with an App should be done using the
  ## platform-specific service, but some tool use-cases require a summary of all
  ## known Apps (such as for App selector interfaces).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Token returned from a previous call to `SearchFirebaseApps` indicating
  ## where in the set of Apps to resume listing.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579246 = newJObject()
  var query_579247 = newJObject()
  add(query_579247, "key", newJString(key))
  add(query_579247, "prettyPrint", newJBool(prettyPrint))
  add(query_579247, "oauth_token", newJString(oauthToken))
  add(query_579247, "$.xgafv", newJString(Xgafv))
  add(query_579247, "pageSize", newJInt(pageSize))
  add(query_579247, "alt", newJString(alt))
  add(query_579247, "uploadType", newJString(uploadType))
  add(query_579247, "quotaUser", newJString(quotaUser))
  add(query_579247, "pageToken", newJString(pageToken))
  add(query_579247, "callback", newJString(callback))
  add(path_579246, "parent", newJString(parent))
  add(query_579247, "fields", newJString(fields))
  add(query_579247, "access_token", newJString(accessToken))
  add(query_579247, "upload_protocol", newJString(uploadProtocol))
  result = call_579245.call(path_579246, query_579247, nil, nil, nil)

var firebaseProjectsSearchApps* = Call_FirebaseProjectsSearchApps_579227(
    name: "firebaseProjectsSearchApps", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}:searchApps",
    validator: validate_FirebaseProjectsSearchApps_579228, base: "/",
    url: url_FirebaseProjectsSearchApps_579229, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAddFirebase_579248 = ref object of OpenApiRestCall_578339
proc url_FirebaseProjectsAddFirebase_579250(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: ":addFirebase")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsAddFirebase_579249(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds Firebase resources to the specified existing
  ## [Google Cloud Platform (GCP) `Project`]
  ## (https://cloud.google.com/resource-manager/reference/rest/v1/projects).
  ## <br>
  ## <br>Since a FirebaseProject is actually also a GCP `Project`, a
  ## `FirebaseProject` uses underlying GCP identifiers (most importantly,
  ## the `projectId`) as its own for easy interop with GCP APIs.
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations).
  ## Poll the `Operation` to track the provisioning process by calling
  ## GetOperation until
  ## [`done`](../../v1beta1/operations#Operation.FIELDS.done) is `true`. When
  ## `done` is `true`, the `Operation` has either succeeded or failed. If the
  ## `Operation` succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) is set to
  ## a FirebaseProject; if the `Operation` failed, its
  ## [`error`](../../v1beta1/operations#Operation.FIELDS.error) is set to a
  ## google.rpc.Status. The `Operation` is automatically deleted after
  ## completion, so there is no need to call
  ## DeleteOperation.
  ## <br>
  ## <br>This method does not modify any billing account information on the
  ## underlying GCP `Project`.
  ## <br>
  ## <br>To call `AddFirebase`, a member must be an Editor or Owner for the
  ## existing GCP `Project`. Service accounts cannot call `AddFirebase`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The resource name of the GCP `Project` to which Firebase resources will be
  ## added, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ## After calling `AddFirebase`, the
  ## 
  ## [`projectId`](https://cloud.google.com/resource-manager/reference/rest/v1/projects#Project.FIELDS.project_id)
  ## of the GCP `Project` is also the `projectId` of the FirebaseProject.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579251 = path.getOrDefault("project")
  valid_579251 = validateParameter(valid_579251, JString, required = true,
                                 default = nil)
  if valid_579251 != nil:
    section.add "project", valid_579251
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
  var valid_579252 = query.getOrDefault("key")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "key", valid_579252
  var valid_579253 = query.getOrDefault("prettyPrint")
  valid_579253 = validateParameter(valid_579253, JBool, required = false,
                                 default = newJBool(true))
  if valid_579253 != nil:
    section.add "prettyPrint", valid_579253
  var valid_579254 = query.getOrDefault("oauth_token")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "oauth_token", valid_579254
  var valid_579255 = query.getOrDefault("$.xgafv")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = newJString("1"))
  if valid_579255 != nil:
    section.add "$.xgafv", valid_579255
  var valid_579256 = query.getOrDefault("alt")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = newJString("json"))
  if valid_579256 != nil:
    section.add "alt", valid_579256
  var valid_579257 = query.getOrDefault("uploadType")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "uploadType", valid_579257
  var valid_579258 = query.getOrDefault("quotaUser")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "quotaUser", valid_579258
  var valid_579259 = query.getOrDefault("callback")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "callback", valid_579259
  var valid_579260 = query.getOrDefault("fields")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "fields", valid_579260
  var valid_579261 = query.getOrDefault("access_token")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "access_token", valid_579261
  var valid_579262 = query.getOrDefault("upload_protocol")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "upload_protocol", valid_579262
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

proc call*(call_579264: Call_FirebaseProjectsAddFirebase_579248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds Firebase resources to the specified existing
  ## [Google Cloud Platform (GCP) `Project`]
  ## (https://cloud.google.com/resource-manager/reference/rest/v1/projects).
  ## <br>
  ## <br>Since a FirebaseProject is actually also a GCP `Project`, a
  ## `FirebaseProject` uses underlying GCP identifiers (most importantly,
  ## the `projectId`) as its own for easy interop with GCP APIs.
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations).
  ## Poll the `Operation` to track the provisioning process by calling
  ## GetOperation until
  ## [`done`](../../v1beta1/operations#Operation.FIELDS.done) is `true`. When
  ## `done` is `true`, the `Operation` has either succeeded or failed. If the
  ## `Operation` succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) is set to
  ## a FirebaseProject; if the `Operation` failed, its
  ## [`error`](../../v1beta1/operations#Operation.FIELDS.error) is set to a
  ## google.rpc.Status. The `Operation` is automatically deleted after
  ## completion, so there is no need to call
  ## DeleteOperation.
  ## <br>
  ## <br>This method does not modify any billing account information on the
  ## underlying GCP `Project`.
  ## <br>
  ## <br>To call `AddFirebase`, a member must be an Editor or Owner for the
  ## existing GCP `Project`. Service accounts cannot call `AddFirebase`.
  ## 
  let valid = call_579264.validator(path, query, header, formData, body)
  let scheme = call_579264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579264.url(scheme.get, call_579264.host, call_579264.base,
                         call_579264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579264, url, valid)

proc call*(call_579265: Call_FirebaseProjectsAddFirebase_579248; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsAddFirebase
  ## Adds Firebase resources to the specified existing
  ## [Google Cloud Platform (GCP) `Project`]
  ## (https://cloud.google.com/resource-manager/reference/rest/v1/projects).
  ## <br>
  ## <br>Since a FirebaseProject is actually also a GCP `Project`, a
  ## `FirebaseProject` uses underlying GCP identifiers (most importantly,
  ## the `projectId`) as its own for easy interop with GCP APIs.
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations).
  ## Poll the `Operation` to track the provisioning process by calling
  ## GetOperation until
  ## [`done`](../../v1beta1/operations#Operation.FIELDS.done) is `true`. When
  ## `done` is `true`, the `Operation` has either succeeded or failed. If the
  ## `Operation` succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) is set to
  ## a FirebaseProject; if the `Operation` failed, its
  ## [`error`](../../v1beta1/operations#Operation.FIELDS.error) is set to a
  ## google.rpc.Status. The `Operation` is automatically deleted after
  ## completion, so there is no need to call
  ## DeleteOperation.
  ## <br>
  ## <br>This method does not modify any billing account information on the
  ## underlying GCP `Project`.
  ## <br>
  ## <br>To call `AddFirebase`, a member must be an Editor or Owner for the
  ## existing GCP `Project`. Service accounts cannot call `AddFirebase`.
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
  ##   project: string (required)
  ##          : The resource name of the GCP `Project` to which Firebase resources will be
  ## added, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ## After calling `AddFirebase`, the
  ## 
  ## [`projectId`](https://cloud.google.com/resource-manager/reference/rest/v1/projects#Project.FIELDS.project_id)
  ## of the GCP `Project` is also the `projectId` of the FirebaseProject.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579266 = newJObject()
  var query_579267 = newJObject()
  var body_579268 = newJObject()
  add(query_579267, "key", newJString(key))
  add(query_579267, "prettyPrint", newJBool(prettyPrint))
  add(query_579267, "oauth_token", newJString(oauthToken))
  add(query_579267, "$.xgafv", newJString(Xgafv))
  add(query_579267, "alt", newJString(alt))
  add(query_579267, "uploadType", newJString(uploadType))
  add(query_579267, "quotaUser", newJString(quotaUser))
  add(path_579266, "project", newJString(project))
  if body != nil:
    body_579268 = body
  add(query_579267, "callback", newJString(callback))
  add(query_579267, "fields", newJString(fields))
  add(query_579267, "access_token", newJString(accessToken))
  add(query_579267, "upload_protocol", newJString(uploadProtocol))
  result = call_579265.call(path_579266, query_579267, nil, nil, body_579268)

var firebaseProjectsAddFirebase* = Call_FirebaseProjectsAddFirebase_579248(
    name: "firebaseProjectsAddFirebase", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{project}:addFirebase",
    validator: validate_FirebaseProjectsAddFirebase_579249, base: "/",
    url: url_FirebaseProjectsAddFirebase_579250, schemes: {Scheme.Https})
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
