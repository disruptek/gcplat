
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Storage
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Stores and retrieves potentially large, immutable data objects.
## 
## https://developers.google.com/storage/docs/json_api/
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

  OpenApiRestCall_579380 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579380](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579380): Option[Scheme] {.used.} =
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
  gcpServiceName = "storage"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StorageBucketsInsert_579926 = ref object of OpenApiRestCall_579380
proc url_StorageBucketsInsert_579928(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsInsert_579927(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new bucket.
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
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this bucket.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: JString (required)
  ##          : A valid API project identifier.
  ##   predefinedDefaultObjectAcl: JString
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the bucket resource specifies acl or defaultObjectAcl properties, when it defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579929 = query.getOrDefault("key")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "key", valid_579929
  var valid_579930 = query.getOrDefault("prettyPrint")
  valid_579930 = validateParameter(valid_579930, JBool, required = false,
                                 default = newJBool(true))
  if valid_579930 != nil:
    section.add "prettyPrint", valid_579930
  var valid_579931 = query.getOrDefault("oauth_token")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = nil)
  if valid_579931 != nil:
    section.add "oauth_token", valid_579931
  var valid_579932 = query.getOrDefault("userProject")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "userProject", valid_579932
  var valid_579933 = query.getOrDefault("predefinedAcl")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_579933 != nil:
    section.add "predefinedAcl", valid_579933
  var valid_579934 = query.getOrDefault("alt")
  valid_579934 = validateParameter(valid_579934, JString, required = false,
                                 default = newJString("json"))
  if valid_579934 != nil:
    section.add "alt", valid_579934
  var valid_579935 = query.getOrDefault("userIp")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = nil)
  if valid_579935 != nil:
    section.add "userIp", valid_579935
  var valid_579936 = query.getOrDefault("quotaUser")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "quotaUser", valid_579936
  assert query != nil, "query argument is necessary due to required `project` field"
  var valid_579937 = query.getOrDefault("project")
  valid_579937 = validateParameter(valid_579937, JString, required = true,
                                 default = nil)
  if valid_579937 != nil:
    section.add "project", valid_579937
  var valid_579938 = query.getOrDefault("predefinedDefaultObjectAcl")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_579938 != nil:
    section.add "predefinedDefaultObjectAcl", valid_579938
  var valid_579939 = query.getOrDefault("provisionalUserProject")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = nil)
  if valid_579939 != nil:
    section.add "provisionalUserProject", valid_579939
  var valid_579940 = query.getOrDefault("projection")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = newJString("full"))
  if valid_579940 != nil:
    section.add "projection", valid_579940
  var valid_579941 = query.getOrDefault("fields")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "fields", valid_579941
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

proc call*(call_579943: Call_StorageBucketsInsert_579926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new bucket.
  ## 
  let valid = call_579943.validator(path, query, header, formData, body)
  let scheme = call_579943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579943.url(scheme.get, call_579943.host, call_579943.base,
                         call_579943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579943, url, valid)

proc call*(call_579944: Call_StorageBucketsInsert_579926; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; predefinedAcl: string = "authenticatedRead";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil;
          predefinedDefaultObjectAcl: string = "authenticatedRead";
          provisionalUserProject: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageBucketsInsert
  ## Creates a new bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this bucket.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : A valid API project identifier.
  ##   body: JObject
  ##   predefinedDefaultObjectAcl: string
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the bucket resource specifies acl or defaultObjectAcl properties, when it defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579945 = newJObject()
  var body_579946 = newJObject()
  add(query_579945, "key", newJString(key))
  add(query_579945, "prettyPrint", newJBool(prettyPrint))
  add(query_579945, "oauth_token", newJString(oauthToken))
  add(query_579945, "userProject", newJString(userProject))
  add(query_579945, "predefinedAcl", newJString(predefinedAcl))
  add(query_579945, "alt", newJString(alt))
  add(query_579945, "userIp", newJString(userIp))
  add(query_579945, "quotaUser", newJString(quotaUser))
  add(query_579945, "project", newJString(project))
  if body != nil:
    body_579946 = body
  add(query_579945, "predefinedDefaultObjectAcl",
      newJString(predefinedDefaultObjectAcl))
  add(query_579945, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579945, "projection", newJString(projection))
  add(query_579945, "fields", newJString(fields))
  result = call_579944.call(nil, query_579945, nil, nil, body_579946)

var storageBucketsInsert* = Call_StorageBucketsInsert_579926(
    name: "storageBucketsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b",
    validator: validate_StorageBucketsInsert_579927, base: "/storage/v1",
    url: url_StorageBucketsInsert_579928, schemes: {Scheme.Https})
type
  Call_StorageBucketsList_579650 = ref object of OpenApiRestCall_579380
proc url_StorageBucketsList_579652(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsList_579651(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a list of buckets for a given project.
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
  ##   prefix: JString
  ##         : Filter results to buckets whose names begin with this prefix.
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: JString (required)
  ##          : A valid API project identifier.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of buckets to return in a single response. The service will use this parameter or 1,000 items, whichever is smaller.
  section = newJObject()
  var valid_579764 = query.getOrDefault("key")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "key", valid_579764
  var valid_579778 = query.getOrDefault("prettyPrint")
  valid_579778 = validateParameter(valid_579778, JBool, required = false,
                                 default = newJBool(true))
  if valid_579778 != nil:
    section.add "prettyPrint", valid_579778
  var valid_579779 = query.getOrDefault("oauth_token")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "oauth_token", valid_579779
  var valid_579780 = query.getOrDefault("prefix")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = nil)
  if valid_579780 != nil:
    section.add "prefix", valid_579780
  var valid_579781 = query.getOrDefault("userProject")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = nil)
  if valid_579781 != nil:
    section.add "userProject", valid_579781
  var valid_579782 = query.getOrDefault("alt")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = newJString("json"))
  if valid_579782 != nil:
    section.add "alt", valid_579782
  var valid_579783 = query.getOrDefault("userIp")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "userIp", valid_579783
  var valid_579784 = query.getOrDefault("quotaUser")
  valid_579784 = validateParameter(valid_579784, JString, required = false,
                                 default = nil)
  if valid_579784 != nil:
    section.add "quotaUser", valid_579784
  assert query != nil, "query argument is necessary due to required `project` field"
  var valid_579785 = query.getOrDefault("project")
  valid_579785 = validateParameter(valid_579785, JString, required = true,
                                 default = nil)
  if valid_579785 != nil:
    section.add "project", valid_579785
  var valid_579786 = query.getOrDefault("pageToken")
  valid_579786 = validateParameter(valid_579786, JString, required = false,
                                 default = nil)
  if valid_579786 != nil:
    section.add "pageToken", valid_579786
  var valid_579787 = query.getOrDefault("provisionalUserProject")
  valid_579787 = validateParameter(valid_579787, JString, required = false,
                                 default = nil)
  if valid_579787 != nil:
    section.add "provisionalUserProject", valid_579787
  var valid_579788 = query.getOrDefault("projection")
  valid_579788 = validateParameter(valid_579788, JString, required = false,
                                 default = newJString("full"))
  if valid_579788 != nil:
    section.add "projection", valid_579788
  var valid_579789 = query.getOrDefault("fields")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = nil)
  if valid_579789 != nil:
    section.add "fields", valid_579789
  var valid_579791 = query.getOrDefault("maxResults")
  valid_579791 = validateParameter(valid_579791, JInt, required = false,
                                 default = newJInt(1000))
  if valid_579791 != nil:
    section.add "maxResults", valid_579791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579814: Call_StorageBucketsList_579650; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of buckets for a given project.
  ## 
  let valid = call_579814.validator(path, query, header, formData, body)
  let scheme = call_579814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579814.url(scheme.get, call_579814.host, call_579814.base,
                         call_579814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579814, url, valid)

proc call*(call_579885: Call_StorageBucketsList_579650; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          prefix: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          provisionalUserProject: string = ""; projection: string = "full";
          fields: string = ""; maxResults: int = 1000): Recallable =
  ## storageBucketsList
  ## Retrieves a list of buckets for a given project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   prefix: string
  ##         : Filter results to buckets whose names begin with this prefix.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : A valid API project identifier.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of buckets to return in a single response. The service will use this parameter or 1,000 items, whichever is smaller.
  var query_579886 = newJObject()
  add(query_579886, "key", newJString(key))
  add(query_579886, "prettyPrint", newJBool(prettyPrint))
  add(query_579886, "oauth_token", newJString(oauthToken))
  add(query_579886, "prefix", newJString(prefix))
  add(query_579886, "userProject", newJString(userProject))
  add(query_579886, "alt", newJString(alt))
  add(query_579886, "userIp", newJString(userIp))
  add(query_579886, "quotaUser", newJString(quotaUser))
  add(query_579886, "project", newJString(project))
  add(query_579886, "pageToken", newJString(pageToken))
  add(query_579886, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579886, "projection", newJString(projection))
  add(query_579886, "fields", newJString(fields))
  add(query_579886, "maxResults", newJInt(maxResults))
  result = call_579885.call(nil, query_579886, nil, nil, nil)

var storageBucketsList* = Call_StorageBucketsList_579650(
    name: "storageBucketsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b", validator: validate_StorageBucketsList_579651,
    base: "/storage/v1", url: url_StorageBucketsList_579652, schemes: {Scheme.Https})
type
  Call_StorageBucketsUpdate_579981 = ref object of OpenApiRestCall_579380
proc url_StorageBucketsUpdate_579983(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketsUpdate_579982(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579984 = path.getOrDefault("bucket")
  valid_579984 = validateParameter(valid_579984, JString, required = true,
                                 default = nil)
  if valid_579984 != nil:
    section.add "bucket", valid_579984
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this bucket.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   predefinedDefaultObjectAcl: JString
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579985 = query.getOrDefault("key")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "key", valid_579985
  var valid_579986 = query.getOrDefault("prettyPrint")
  valid_579986 = validateParameter(valid_579986, JBool, required = false,
                                 default = newJBool(true))
  if valid_579986 != nil:
    section.add "prettyPrint", valid_579986
  var valid_579987 = query.getOrDefault("oauth_token")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "oauth_token", valid_579987
  var valid_579988 = query.getOrDefault("userProject")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "userProject", valid_579988
  var valid_579989 = query.getOrDefault("predefinedAcl")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_579989 != nil:
    section.add "predefinedAcl", valid_579989
  var valid_579990 = query.getOrDefault("alt")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = newJString("json"))
  if valid_579990 != nil:
    section.add "alt", valid_579990
  var valid_579991 = query.getOrDefault("userIp")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "userIp", valid_579991
  var valid_579992 = query.getOrDefault("quotaUser")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "quotaUser", valid_579992
  var valid_579993 = query.getOrDefault("ifMetagenerationMatch")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "ifMetagenerationMatch", valid_579993
  var valid_579994 = query.getOrDefault("predefinedDefaultObjectAcl")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_579994 != nil:
    section.add "predefinedDefaultObjectAcl", valid_579994
  var valid_579995 = query.getOrDefault("provisionalUserProject")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "provisionalUserProject", valid_579995
  var valid_579996 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "ifMetagenerationNotMatch", valid_579996
  var valid_579997 = query.getOrDefault("projection")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("full"))
  if valid_579997 != nil:
    section.add "projection", valid_579997
  var valid_579998 = query.getOrDefault("fields")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "fields", valid_579998
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

proc call*(call_580000: Call_StorageBucketsUpdate_579981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ## 
  let valid = call_580000.validator(path, query, header, formData, body)
  let scheme = call_580000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580000.url(scheme.get, call_580000.host, call_580000.base,
                         call_580000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580000, url, valid)

proc call*(call_580001: Call_StorageBucketsUpdate_579981; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; predefinedAcl: string = "authenticatedRead";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          predefinedDefaultObjectAcl: string = "authenticatedRead";
          provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageBucketsUpdate
  ## Updates a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this bucket.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   predefinedDefaultObjectAcl: string
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580002 = newJObject()
  var query_580003 = newJObject()
  var body_580004 = newJObject()
  add(query_580003, "key", newJString(key))
  add(query_580003, "prettyPrint", newJBool(prettyPrint))
  add(query_580003, "oauth_token", newJString(oauthToken))
  add(query_580003, "userProject", newJString(userProject))
  add(query_580003, "predefinedAcl", newJString(predefinedAcl))
  add(query_580003, "alt", newJString(alt))
  add(query_580003, "userIp", newJString(userIp))
  add(query_580003, "quotaUser", newJString(quotaUser))
  add(query_580003, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_580002, "bucket", newJString(bucket))
  if body != nil:
    body_580004 = body
  add(query_580003, "predefinedDefaultObjectAcl",
      newJString(predefinedDefaultObjectAcl))
  add(query_580003, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580003, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580003, "projection", newJString(projection))
  add(query_580003, "fields", newJString(fields))
  result = call_580001.call(path_580002, query_580003, nil, nil, body_580004)

var storageBucketsUpdate* = Call_StorageBucketsUpdate_579981(
    name: "storageBucketsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsUpdate_579982, base: "/storage/v1",
    url: url_StorageBucketsUpdate_579983, schemes: {Scheme.Https})
type
  Call_StorageBucketsGet_579947 = ref object of OpenApiRestCall_579380
proc url_StorageBucketsGet_579949(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketsGet_579948(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns metadata for the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579964 = path.getOrDefault("bucket")
  valid_579964 = validateParameter(valid_579964, JString, required = true,
                                 default = nil)
  if valid_579964 != nil:
    section.add "bucket", valid_579964
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579965 = query.getOrDefault("key")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "key", valid_579965
  var valid_579966 = query.getOrDefault("prettyPrint")
  valid_579966 = validateParameter(valid_579966, JBool, required = false,
                                 default = newJBool(true))
  if valid_579966 != nil:
    section.add "prettyPrint", valid_579966
  var valid_579967 = query.getOrDefault("oauth_token")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "oauth_token", valid_579967
  var valid_579968 = query.getOrDefault("userProject")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "userProject", valid_579968
  var valid_579969 = query.getOrDefault("alt")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = newJString("json"))
  if valid_579969 != nil:
    section.add "alt", valid_579969
  var valid_579970 = query.getOrDefault("userIp")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "userIp", valid_579970
  var valid_579971 = query.getOrDefault("quotaUser")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "quotaUser", valid_579971
  var valid_579972 = query.getOrDefault("ifMetagenerationMatch")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "ifMetagenerationMatch", valid_579972
  var valid_579973 = query.getOrDefault("provisionalUserProject")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "provisionalUserProject", valid_579973
  var valid_579974 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "ifMetagenerationNotMatch", valid_579974
  var valid_579975 = query.getOrDefault("projection")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = newJString("full"))
  if valid_579975 != nil:
    section.add "projection", valid_579975
  var valid_579976 = query.getOrDefault("fields")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "fields", valid_579976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579977: Call_StorageBucketsGet_579947; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata for the specified bucket.
  ## 
  let valid = call_579977.validator(path, query, header, formData, body)
  let scheme = call_579977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579977.url(scheme.get, call_579977.host, call_579977.base,
                         call_579977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579977, url, valid)

proc call*(call_579978: Call_StorageBucketsGet_579947; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; ifMetagenerationMatch: string = "";
          provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageBucketsGet
  ## Returns metadata for the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579979 = newJObject()
  var query_579980 = newJObject()
  add(query_579980, "key", newJString(key))
  add(query_579980, "prettyPrint", newJBool(prettyPrint))
  add(query_579980, "oauth_token", newJString(oauthToken))
  add(query_579980, "userProject", newJString(userProject))
  add(query_579980, "alt", newJString(alt))
  add(query_579980, "userIp", newJString(userIp))
  add(query_579980, "quotaUser", newJString(quotaUser))
  add(query_579980, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_579979, "bucket", newJString(bucket))
  add(query_579980, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579980, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579980, "projection", newJString(projection))
  add(query_579980, "fields", newJString(fields))
  result = call_579978.call(path_579979, query_579980, nil, nil, nil)

var storageBucketsGet* = Call_StorageBucketsGet_579947(name: "storageBucketsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsGet_579948, base: "/storage/v1",
    url: url_StorageBucketsGet_579949, schemes: {Scheme.Https})
type
  Call_StorageBucketsPatch_580024 = ref object of OpenApiRestCall_579380
proc url_StorageBucketsPatch_580026(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketsPatch_580025(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Patches a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580027 = path.getOrDefault("bucket")
  valid_580027 = validateParameter(valid_580027, JString, required = true,
                                 default = nil)
  if valid_580027 != nil:
    section.add "bucket", valid_580027
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this bucket.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   predefinedDefaultObjectAcl: JString
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580028 = query.getOrDefault("key")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "key", valid_580028
  var valid_580029 = query.getOrDefault("prettyPrint")
  valid_580029 = validateParameter(valid_580029, JBool, required = false,
                                 default = newJBool(true))
  if valid_580029 != nil:
    section.add "prettyPrint", valid_580029
  var valid_580030 = query.getOrDefault("oauth_token")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "oauth_token", valid_580030
  var valid_580031 = query.getOrDefault("userProject")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "userProject", valid_580031
  var valid_580032 = query.getOrDefault("predefinedAcl")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_580032 != nil:
    section.add "predefinedAcl", valid_580032
  var valid_580033 = query.getOrDefault("alt")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = newJString("json"))
  if valid_580033 != nil:
    section.add "alt", valid_580033
  var valid_580034 = query.getOrDefault("userIp")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "userIp", valid_580034
  var valid_580035 = query.getOrDefault("quotaUser")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "quotaUser", valid_580035
  var valid_580036 = query.getOrDefault("ifMetagenerationMatch")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "ifMetagenerationMatch", valid_580036
  var valid_580037 = query.getOrDefault("predefinedDefaultObjectAcl")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_580037 != nil:
    section.add "predefinedDefaultObjectAcl", valid_580037
  var valid_580038 = query.getOrDefault("provisionalUserProject")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "provisionalUserProject", valid_580038
  var valid_580039 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "ifMetagenerationNotMatch", valid_580039
  var valid_580040 = query.getOrDefault("projection")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = newJString("full"))
  if valid_580040 != nil:
    section.add "projection", valid_580040
  var valid_580041 = query.getOrDefault("fields")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "fields", valid_580041
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

proc call*(call_580043: Call_StorageBucketsPatch_580024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ## 
  let valid = call_580043.validator(path, query, header, formData, body)
  let scheme = call_580043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580043.url(scheme.get, call_580043.host, call_580043.base,
                         call_580043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580043, url, valid)

proc call*(call_580044: Call_StorageBucketsPatch_580024; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; predefinedAcl: string = "authenticatedRead";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          predefinedDefaultObjectAcl: string = "authenticatedRead";
          provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageBucketsPatch
  ## Patches a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this bucket.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   predefinedDefaultObjectAcl: string
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580045 = newJObject()
  var query_580046 = newJObject()
  var body_580047 = newJObject()
  add(query_580046, "key", newJString(key))
  add(query_580046, "prettyPrint", newJBool(prettyPrint))
  add(query_580046, "oauth_token", newJString(oauthToken))
  add(query_580046, "userProject", newJString(userProject))
  add(query_580046, "predefinedAcl", newJString(predefinedAcl))
  add(query_580046, "alt", newJString(alt))
  add(query_580046, "userIp", newJString(userIp))
  add(query_580046, "quotaUser", newJString(quotaUser))
  add(query_580046, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_580045, "bucket", newJString(bucket))
  if body != nil:
    body_580047 = body
  add(query_580046, "predefinedDefaultObjectAcl",
      newJString(predefinedDefaultObjectAcl))
  add(query_580046, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580046, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580046, "projection", newJString(projection))
  add(query_580046, "fields", newJString(fields))
  result = call_580044.call(path_580045, query_580046, nil, nil, body_580047)

var storageBucketsPatch* = Call_StorageBucketsPatch_580024(
    name: "storageBucketsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsPatch_580025, base: "/storage/v1",
    url: url_StorageBucketsPatch_580026, schemes: {Scheme.Https})
type
  Call_StorageBucketsDelete_580005 = ref object of OpenApiRestCall_579380
proc url_StorageBucketsDelete_580007(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketsDelete_580006(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes an empty bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580008 = path.getOrDefault("bucket")
  valid_580008 = validateParameter(valid_580008, JString, required = true,
                                 default = nil)
  if valid_580008 != nil:
    section.add "bucket", valid_580008
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : If set, only deletes the bucket if its metageneration matches this value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : If set, only deletes the bucket if its metageneration does not match this value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580009 = query.getOrDefault("key")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "key", valid_580009
  var valid_580010 = query.getOrDefault("prettyPrint")
  valid_580010 = validateParameter(valid_580010, JBool, required = false,
                                 default = newJBool(true))
  if valid_580010 != nil:
    section.add "prettyPrint", valid_580010
  var valid_580011 = query.getOrDefault("oauth_token")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "oauth_token", valid_580011
  var valid_580012 = query.getOrDefault("userProject")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "userProject", valid_580012
  var valid_580013 = query.getOrDefault("alt")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = newJString("json"))
  if valid_580013 != nil:
    section.add "alt", valid_580013
  var valid_580014 = query.getOrDefault("userIp")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "userIp", valid_580014
  var valid_580015 = query.getOrDefault("quotaUser")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "quotaUser", valid_580015
  var valid_580016 = query.getOrDefault("ifMetagenerationMatch")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "ifMetagenerationMatch", valid_580016
  var valid_580017 = query.getOrDefault("provisionalUserProject")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "provisionalUserProject", valid_580017
  var valid_580018 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "ifMetagenerationNotMatch", valid_580018
  var valid_580019 = query.getOrDefault("fields")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "fields", valid_580019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580020: Call_StorageBucketsDelete_580005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes an empty bucket.
  ## 
  let valid = call_580020.validator(path, query, header, formData, body)
  let scheme = call_580020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580020.url(scheme.get, call_580020.host, call_580020.base,
                         call_580020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580020, url, valid)

proc call*(call_580021: Call_StorageBucketsDelete_580005; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; ifMetagenerationMatch: string = "";
          provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; fields: string = ""): Recallable =
  ## storageBucketsDelete
  ## Permanently deletes an empty bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : If set, only deletes the bucket if its metageneration matches this value.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : If set, only deletes the bucket if its metageneration does not match this value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580022 = newJObject()
  var query_580023 = newJObject()
  add(query_580023, "key", newJString(key))
  add(query_580023, "prettyPrint", newJBool(prettyPrint))
  add(query_580023, "oauth_token", newJString(oauthToken))
  add(query_580023, "userProject", newJString(userProject))
  add(query_580023, "alt", newJString(alt))
  add(query_580023, "userIp", newJString(userIp))
  add(query_580023, "quotaUser", newJString(quotaUser))
  add(query_580023, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_580022, "bucket", newJString(bucket))
  add(query_580023, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580023, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580023, "fields", newJString(fields))
  result = call_580021.call(path_580022, query_580023, nil, nil, nil)

var storageBucketsDelete* = Call_StorageBucketsDelete_580005(
    name: "storageBucketsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsDelete_580006, base: "/storage/v1",
    url: url_StorageBucketsDelete_580007, schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsInsert_580065 = ref object of OpenApiRestCall_579380
proc url_StorageBucketAccessControlsInsert_580067(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsInsert_580066(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new ACL entry on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580068 = path.getOrDefault("bucket")
  valid_580068 = validateParameter(valid_580068, JString, required = true,
                                 default = nil)
  if valid_580068 != nil:
    section.add "bucket", valid_580068
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580069 = query.getOrDefault("key")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "key", valid_580069
  var valid_580070 = query.getOrDefault("prettyPrint")
  valid_580070 = validateParameter(valid_580070, JBool, required = false,
                                 default = newJBool(true))
  if valid_580070 != nil:
    section.add "prettyPrint", valid_580070
  var valid_580071 = query.getOrDefault("oauth_token")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "oauth_token", valid_580071
  var valid_580072 = query.getOrDefault("userProject")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "userProject", valid_580072
  var valid_580073 = query.getOrDefault("alt")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = newJString("json"))
  if valid_580073 != nil:
    section.add "alt", valid_580073
  var valid_580074 = query.getOrDefault("userIp")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "userIp", valid_580074
  var valid_580075 = query.getOrDefault("quotaUser")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "quotaUser", valid_580075
  var valid_580076 = query.getOrDefault("provisionalUserProject")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "provisionalUserProject", valid_580076
  var valid_580077 = query.getOrDefault("fields")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "fields", valid_580077
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

proc call*(call_580079: Call_StorageBucketAccessControlsInsert_580065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified bucket.
  ## 
  let valid = call_580079.validator(path, query, header, formData, body)
  let scheme = call_580079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580079.url(scheme.get, call_580079.host, call_580079.base,
                         call_580079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580079, url, valid)

proc call*(call_580080: Call_StorageBucketAccessControlsInsert_580065;
          bucket: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketAccessControlsInsert
  ## Creates a new ACL entry on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580081 = newJObject()
  var query_580082 = newJObject()
  var body_580083 = newJObject()
  add(query_580082, "key", newJString(key))
  add(query_580082, "prettyPrint", newJBool(prettyPrint))
  add(query_580082, "oauth_token", newJString(oauthToken))
  add(query_580082, "userProject", newJString(userProject))
  add(query_580082, "alt", newJString(alt))
  add(query_580082, "userIp", newJString(userIp))
  add(query_580082, "quotaUser", newJString(quotaUser))
  add(path_580081, "bucket", newJString(bucket))
  if body != nil:
    body_580083 = body
  add(query_580082, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580082, "fields", newJString(fields))
  result = call_580080.call(path_580081, query_580082, nil, nil, body_580083)

var storageBucketAccessControlsInsert* = Call_StorageBucketAccessControlsInsert_580065(
    name: "storageBucketAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsInsert_580066,
    base: "/storage/v1", url: url_StorageBucketAccessControlsInsert_580067,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsList_580048 = ref object of OpenApiRestCall_579380
proc url_StorageBucketAccessControlsList_580050(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsList_580049(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves ACL entries on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580051 = path.getOrDefault("bucket")
  valid_580051 = validateParameter(valid_580051, JString, required = true,
                                 default = nil)
  if valid_580051 != nil:
    section.add "bucket", valid_580051
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580052 = query.getOrDefault("key")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "key", valid_580052
  var valid_580053 = query.getOrDefault("prettyPrint")
  valid_580053 = validateParameter(valid_580053, JBool, required = false,
                                 default = newJBool(true))
  if valid_580053 != nil:
    section.add "prettyPrint", valid_580053
  var valid_580054 = query.getOrDefault("oauth_token")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "oauth_token", valid_580054
  var valid_580055 = query.getOrDefault("userProject")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "userProject", valid_580055
  var valid_580056 = query.getOrDefault("alt")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("json"))
  if valid_580056 != nil:
    section.add "alt", valid_580056
  var valid_580057 = query.getOrDefault("userIp")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "userIp", valid_580057
  var valid_580058 = query.getOrDefault("quotaUser")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "quotaUser", valid_580058
  var valid_580059 = query.getOrDefault("provisionalUserProject")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "provisionalUserProject", valid_580059
  var valid_580060 = query.getOrDefault("fields")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "fields", valid_580060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580061: Call_StorageBucketAccessControlsList_580048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified bucket.
  ## 
  let valid = call_580061.validator(path, query, header, formData, body)
  let scheme = call_580061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580061.url(scheme.get, call_580061.host, call_580061.base,
                         call_580061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580061, url, valid)

proc call*(call_580062: Call_StorageBucketAccessControlsList_580048;
          bucket: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketAccessControlsList
  ## Retrieves ACL entries on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580063 = newJObject()
  var query_580064 = newJObject()
  add(query_580064, "key", newJString(key))
  add(query_580064, "prettyPrint", newJBool(prettyPrint))
  add(query_580064, "oauth_token", newJString(oauthToken))
  add(query_580064, "userProject", newJString(userProject))
  add(query_580064, "alt", newJString(alt))
  add(query_580064, "userIp", newJString(userIp))
  add(query_580064, "quotaUser", newJString(quotaUser))
  add(path_580063, "bucket", newJString(bucket))
  add(query_580064, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580064, "fields", newJString(fields))
  result = call_580062.call(path_580063, query_580064, nil, nil, nil)

var storageBucketAccessControlsList* = Call_StorageBucketAccessControlsList_580048(
    name: "storageBucketAccessControlsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsList_580049,
    base: "/storage/v1", url: url_StorageBucketAccessControlsList_580050,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsUpdate_580102 = ref object of OpenApiRestCall_579380
proc url_StorageBucketAccessControlsUpdate_580104(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsUpdate_580103(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an ACL entry on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580105 = path.getOrDefault("bucket")
  valid_580105 = validateParameter(valid_580105, JString, required = true,
                                 default = nil)
  if valid_580105 != nil:
    section.add "bucket", valid_580105
  var valid_580106 = path.getOrDefault("entity")
  valid_580106 = validateParameter(valid_580106, JString, required = true,
                                 default = nil)
  if valid_580106 != nil:
    section.add "entity", valid_580106
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580107 = query.getOrDefault("key")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "key", valid_580107
  var valid_580108 = query.getOrDefault("prettyPrint")
  valid_580108 = validateParameter(valid_580108, JBool, required = false,
                                 default = newJBool(true))
  if valid_580108 != nil:
    section.add "prettyPrint", valid_580108
  var valid_580109 = query.getOrDefault("oauth_token")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "oauth_token", valid_580109
  var valid_580110 = query.getOrDefault("userProject")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "userProject", valid_580110
  var valid_580111 = query.getOrDefault("alt")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = newJString("json"))
  if valid_580111 != nil:
    section.add "alt", valid_580111
  var valid_580112 = query.getOrDefault("userIp")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "userIp", valid_580112
  var valid_580113 = query.getOrDefault("quotaUser")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "quotaUser", valid_580113
  var valid_580114 = query.getOrDefault("provisionalUserProject")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "provisionalUserProject", valid_580114
  var valid_580115 = query.getOrDefault("fields")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "fields", valid_580115
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

proc call*(call_580117: Call_StorageBucketAccessControlsUpdate_580102;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified bucket.
  ## 
  let valid = call_580117.validator(path, query, header, formData, body)
  let scheme = call_580117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580117.url(scheme.get, call_580117.host, call_580117.base,
                         call_580117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580117, url, valid)

proc call*(call_580118: Call_StorageBucketAccessControlsUpdate_580102;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketAccessControlsUpdate
  ## Updates an ACL entry on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580119 = newJObject()
  var query_580120 = newJObject()
  var body_580121 = newJObject()
  add(query_580120, "key", newJString(key))
  add(query_580120, "prettyPrint", newJBool(prettyPrint))
  add(query_580120, "oauth_token", newJString(oauthToken))
  add(query_580120, "userProject", newJString(userProject))
  add(query_580120, "alt", newJString(alt))
  add(query_580120, "userIp", newJString(userIp))
  add(query_580120, "quotaUser", newJString(quotaUser))
  add(path_580119, "bucket", newJString(bucket))
  if body != nil:
    body_580121 = body
  add(query_580120, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580119, "entity", newJString(entity))
  add(query_580120, "fields", newJString(fields))
  result = call_580118.call(path_580119, query_580120, nil, nil, body_580121)

var storageBucketAccessControlsUpdate* = Call_StorageBucketAccessControlsUpdate_580102(
    name: "storageBucketAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsUpdate_580103,
    base: "/storage/v1", url: url_StorageBucketAccessControlsUpdate_580104,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsGet_580084 = ref object of OpenApiRestCall_579380
proc url_StorageBucketAccessControlsGet_580086(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsGet_580085(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580087 = path.getOrDefault("bucket")
  valid_580087 = validateParameter(valid_580087, JString, required = true,
                                 default = nil)
  if valid_580087 != nil:
    section.add "bucket", valid_580087
  var valid_580088 = path.getOrDefault("entity")
  valid_580088 = validateParameter(valid_580088, JString, required = true,
                                 default = nil)
  if valid_580088 != nil:
    section.add "entity", valid_580088
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580089 = query.getOrDefault("key")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "key", valid_580089
  var valid_580090 = query.getOrDefault("prettyPrint")
  valid_580090 = validateParameter(valid_580090, JBool, required = false,
                                 default = newJBool(true))
  if valid_580090 != nil:
    section.add "prettyPrint", valid_580090
  var valid_580091 = query.getOrDefault("oauth_token")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "oauth_token", valid_580091
  var valid_580092 = query.getOrDefault("userProject")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "userProject", valid_580092
  var valid_580093 = query.getOrDefault("alt")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = newJString("json"))
  if valid_580093 != nil:
    section.add "alt", valid_580093
  var valid_580094 = query.getOrDefault("userIp")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "userIp", valid_580094
  var valid_580095 = query.getOrDefault("quotaUser")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "quotaUser", valid_580095
  var valid_580096 = query.getOrDefault("provisionalUserProject")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "provisionalUserProject", valid_580096
  var valid_580097 = query.getOrDefault("fields")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "fields", valid_580097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580098: Call_StorageBucketAccessControlsGet_580084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_580098.validator(path, query, header, formData, body)
  let scheme = call_580098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580098.url(scheme.get, call_580098.host, call_580098.base,
                         call_580098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580098, url, valid)

proc call*(call_580099: Call_StorageBucketAccessControlsGet_580084; bucket: string;
          entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketAccessControlsGet
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580100 = newJObject()
  var query_580101 = newJObject()
  add(query_580101, "key", newJString(key))
  add(query_580101, "prettyPrint", newJBool(prettyPrint))
  add(query_580101, "oauth_token", newJString(oauthToken))
  add(query_580101, "userProject", newJString(userProject))
  add(query_580101, "alt", newJString(alt))
  add(query_580101, "userIp", newJString(userIp))
  add(query_580101, "quotaUser", newJString(quotaUser))
  add(path_580100, "bucket", newJString(bucket))
  add(query_580101, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580100, "entity", newJString(entity))
  add(query_580101, "fields", newJString(fields))
  result = call_580099.call(path_580100, query_580101, nil, nil, nil)

var storageBucketAccessControlsGet* = Call_StorageBucketAccessControlsGet_580084(
    name: "storageBucketAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsGet_580085,
    base: "/storage/v1", url: url_StorageBucketAccessControlsGet_580086,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsPatch_580140 = ref object of OpenApiRestCall_579380
proc url_StorageBucketAccessControlsPatch_580142(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsPatch_580141(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches an ACL entry on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580143 = path.getOrDefault("bucket")
  valid_580143 = validateParameter(valid_580143, JString, required = true,
                                 default = nil)
  if valid_580143 != nil:
    section.add "bucket", valid_580143
  var valid_580144 = path.getOrDefault("entity")
  valid_580144 = validateParameter(valid_580144, JString, required = true,
                                 default = nil)
  if valid_580144 != nil:
    section.add "entity", valid_580144
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580145 = query.getOrDefault("key")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "key", valid_580145
  var valid_580146 = query.getOrDefault("prettyPrint")
  valid_580146 = validateParameter(valid_580146, JBool, required = false,
                                 default = newJBool(true))
  if valid_580146 != nil:
    section.add "prettyPrint", valid_580146
  var valid_580147 = query.getOrDefault("oauth_token")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "oauth_token", valid_580147
  var valid_580148 = query.getOrDefault("userProject")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "userProject", valid_580148
  var valid_580149 = query.getOrDefault("alt")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = newJString("json"))
  if valid_580149 != nil:
    section.add "alt", valid_580149
  var valid_580150 = query.getOrDefault("userIp")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "userIp", valid_580150
  var valid_580151 = query.getOrDefault("quotaUser")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "quotaUser", valid_580151
  var valid_580152 = query.getOrDefault("provisionalUserProject")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "provisionalUserProject", valid_580152
  var valid_580153 = query.getOrDefault("fields")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "fields", valid_580153
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

proc call*(call_580155: Call_StorageBucketAccessControlsPatch_580140;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Patches an ACL entry on the specified bucket.
  ## 
  let valid = call_580155.validator(path, query, header, formData, body)
  let scheme = call_580155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580155.url(scheme.get, call_580155.host, call_580155.base,
                         call_580155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580155, url, valid)

proc call*(call_580156: Call_StorageBucketAccessControlsPatch_580140;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketAccessControlsPatch
  ## Patches an ACL entry on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580157 = newJObject()
  var query_580158 = newJObject()
  var body_580159 = newJObject()
  add(query_580158, "key", newJString(key))
  add(query_580158, "prettyPrint", newJBool(prettyPrint))
  add(query_580158, "oauth_token", newJString(oauthToken))
  add(query_580158, "userProject", newJString(userProject))
  add(query_580158, "alt", newJString(alt))
  add(query_580158, "userIp", newJString(userIp))
  add(query_580158, "quotaUser", newJString(quotaUser))
  add(path_580157, "bucket", newJString(bucket))
  if body != nil:
    body_580159 = body
  add(query_580158, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580157, "entity", newJString(entity))
  add(query_580158, "fields", newJString(fields))
  result = call_580156.call(path_580157, query_580158, nil, nil, body_580159)

var storageBucketAccessControlsPatch* = Call_StorageBucketAccessControlsPatch_580140(
    name: "storageBucketAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsPatch_580141,
    base: "/storage/v1", url: url_StorageBucketAccessControlsPatch_580142,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsDelete_580122 = ref object of OpenApiRestCall_579380
proc url_StorageBucketAccessControlsDelete_580124(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsDelete_580123(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes the ACL entry for the specified entity on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580125 = path.getOrDefault("bucket")
  valid_580125 = validateParameter(valid_580125, JString, required = true,
                                 default = nil)
  if valid_580125 != nil:
    section.add "bucket", valid_580125
  var valid_580126 = path.getOrDefault("entity")
  valid_580126 = validateParameter(valid_580126, JString, required = true,
                                 default = nil)
  if valid_580126 != nil:
    section.add "entity", valid_580126
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580127 = query.getOrDefault("key")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "key", valid_580127
  var valid_580128 = query.getOrDefault("prettyPrint")
  valid_580128 = validateParameter(valid_580128, JBool, required = false,
                                 default = newJBool(true))
  if valid_580128 != nil:
    section.add "prettyPrint", valid_580128
  var valid_580129 = query.getOrDefault("oauth_token")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "oauth_token", valid_580129
  var valid_580130 = query.getOrDefault("userProject")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "userProject", valid_580130
  var valid_580131 = query.getOrDefault("alt")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = newJString("json"))
  if valid_580131 != nil:
    section.add "alt", valid_580131
  var valid_580132 = query.getOrDefault("userIp")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "userIp", valid_580132
  var valid_580133 = query.getOrDefault("quotaUser")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "quotaUser", valid_580133
  var valid_580134 = query.getOrDefault("provisionalUserProject")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "provisionalUserProject", valid_580134
  var valid_580135 = query.getOrDefault("fields")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "fields", valid_580135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580136: Call_StorageBucketAccessControlsDelete_580122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_580136.validator(path, query, header, formData, body)
  let scheme = call_580136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580136.url(scheme.get, call_580136.host, call_580136.base,
                         call_580136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580136, url, valid)

proc call*(call_580137: Call_StorageBucketAccessControlsDelete_580122;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketAccessControlsDelete
  ## Permanently deletes the ACL entry for the specified entity on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580138 = newJObject()
  var query_580139 = newJObject()
  add(query_580139, "key", newJString(key))
  add(query_580139, "prettyPrint", newJBool(prettyPrint))
  add(query_580139, "oauth_token", newJString(oauthToken))
  add(query_580139, "userProject", newJString(userProject))
  add(query_580139, "alt", newJString(alt))
  add(query_580139, "userIp", newJString(userIp))
  add(query_580139, "quotaUser", newJString(quotaUser))
  add(path_580138, "bucket", newJString(bucket))
  add(query_580139, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580138, "entity", newJString(entity))
  add(query_580139, "fields", newJString(fields))
  result = call_580137.call(path_580138, query_580139, nil, nil, nil)

var storageBucketAccessControlsDelete* = Call_StorageBucketAccessControlsDelete_580122(
    name: "storageBucketAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsDelete_580123,
    base: "/storage/v1", url: url_StorageBucketAccessControlsDelete_580124,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsInsert_580179 = ref object of OpenApiRestCall_579380
proc url_StorageDefaultObjectAccessControlsInsert_580181(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsInsert_580180(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new default object ACL entry on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580182 = path.getOrDefault("bucket")
  valid_580182 = validateParameter(valid_580182, JString, required = true,
                                 default = nil)
  if valid_580182 != nil:
    section.add "bucket", valid_580182
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
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
  var valid_580186 = query.getOrDefault("userProject")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "userProject", valid_580186
  var valid_580187 = query.getOrDefault("alt")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = newJString("json"))
  if valid_580187 != nil:
    section.add "alt", valid_580187
  var valid_580188 = query.getOrDefault("userIp")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "userIp", valid_580188
  var valid_580189 = query.getOrDefault("quotaUser")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "quotaUser", valid_580189
  var valid_580190 = query.getOrDefault("provisionalUserProject")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "provisionalUserProject", valid_580190
  var valid_580191 = query.getOrDefault("fields")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "fields", valid_580191
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

proc call*(call_580193: Call_StorageDefaultObjectAccessControlsInsert_580179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new default object ACL entry on the specified bucket.
  ## 
  let valid = call_580193.validator(path, query, header, formData, body)
  let scheme = call_580193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580193.url(scheme.get, call_580193.host, call_580193.base,
                         call_580193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580193, url, valid)

proc call*(call_580194: Call_StorageDefaultObjectAccessControlsInsert_580179;
          bucket: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsInsert
  ## Creates a new default object ACL entry on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580195 = newJObject()
  var query_580196 = newJObject()
  var body_580197 = newJObject()
  add(query_580196, "key", newJString(key))
  add(query_580196, "prettyPrint", newJBool(prettyPrint))
  add(query_580196, "oauth_token", newJString(oauthToken))
  add(query_580196, "userProject", newJString(userProject))
  add(query_580196, "alt", newJString(alt))
  add(query_580196, "userIp", newJString(userIp))
  add(query_580196, "quotaUser", newJString(quotaUser))
  add(path_580195, "bucket", newJString(bucket))
  if body != nil:
    body_580197 = body
  add(query_580196, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580196, "fields", newJString(fields))
  result = call_580194.call(path_580195, query_580196, nil, nil, body_580197)

var storageDefaultObjectAccessControlsInsert* = Call_StorageDefaultObjectAccessControlsInsert_580179(
    name: "storageDefaultObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl",
    validator: validate_StorageDefaultObjectAccessControlsInsert_580180,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsInsert_580181,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsList_580160 = ref object of OpenApiRestCall_579380
proc url_StorageDefaultObjectAccessControlsList_580162(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsList_580161(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves default object ACL entries on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580163 = path.getOrDefault("bucket")
  valid_580163 = validateParameter(valid_580163, JString, required = true,
                                 default = nil)
  if valid_580163 != nil:
    section.add "bucket", valid_580163
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : If present, only return default ACL listing if the bucket's current metageneration matches this value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : If present, only return default ACL listing if the bucket's current metageneration does not match the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580164 = query.getOrDefault("key")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "key", valid_580164
  var valid_580165 = query.getOrDefault("prettyPrint")
  valid_580165 = validateParameter(valid_580165, JBool, required = false,
                                 default = newJBool(true))
  if valid_580165 != nil:
    section.add "prettyPrint", valid_580165
  var valid_580166 = query.getOrDefault("oauth_token")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "oauth_token", valid_580166
  var valid_580167 = query.getOrDefault("userProject")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "userProject", valid_580167
  var valid_580168 = query.getOrDefault("alt")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = newJString("json"))
  if valid_580168 != nil:
    section.add "alt", valid_580168
  var valid_580169 = query.getOrDefault("userIp")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "userIp", valid_580169
  var valid_580170 = query.getOrDefault("quotaUser")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "quotaUser", valid_580170
  var valid_580171 = query.getOrDefault("ifMetagenerationMatch")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "ifMetagenerationMatch", valid_580171
  var valid_580172 = query.getOrDefault("provisionalUserProject")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "provisionalUserProject", valid_580172
  var valid_580173 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "ifMetagenerationNotMatch", valid_580173
  var valid_580174 = query.getOrDefault("fields")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "fields", valid_580174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580175: Call_StorageDefaultObjectAccessControlsList_580160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves default object ACL entries on the specified bucket.
  ## 
  let valid = call_580175.validator(path, query, header, formData, body)
  let scheme = call_580175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580175.url(scheme.get, call_580175.host, call_580175.base,
                         call_580175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580175, url, valid)

proc call*(call_580176: Call_StorageDefaultObjectAccessControlsList_580160;
          bucket: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsList
  ## Retrieves default object ACL entries on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : If present, only return default ACL listing if the bucket's current metageneration matches this value.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : If present, only return default ACL listing if the bucket's current metageneration does not match the given value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580177 = newJObject()
  var query_580178 = newJObject()
  add(query_580178, "key", newJString(key))
  add(query_580178, "prettyPrint", newJBool(prettyPrint))
  add(query_580178, "oauth_token", newJString(oauthToken))
  add(query_580178, "userProject", newJString(userProject))
  add(query_580178, "alt", newJString(alt))
  add(query_580178, "userIp", newJString(userIp))
  add(query_580178, "quotaUser", newJString(quotaUser))
  add(query_580178, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_580177, "bucket", newJString(bucket))
  add(query_580178, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580178, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580178, "fields", newJString(fields))
  result = call_580176.call(path_580177, query_580178, nil, nil, nil)

var storageDefaultObjectAccessControlsList* = Call_StorageDefaultObjectAccessControlsList_580160(
    name: "storageDefaultObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl",
    validator: validate_StorageDefaultObjectAccessControlsList_580161,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsList_580162,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsUpdate_580216 = ref object of OpenApiRestCall_579380
proc url_StorageDefaultObjectAccessControlsUpdate_580218(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsUpdate_580217(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a default object ACL entry on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580219 = path.getOrDefault("bucket")
  valid_580219 = validateParameter(valid_580219, JString, required = true,
                                 default = nil)
  if valid_580219 != nil:
    section.add "bucket", valid_580219
  var valid_580220 = path.getOrDefault("entity")
  valid_580220 = validateParameter(valid_580220, JString, required = true,
                                 default = nil)
  if valid_580220 != nil:
    section.add "entity", valid_580220
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580221 = query.getOrDefault("key")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "key", valid_580221
  var valid_580222 = query.getOrDefault("prettyPrint")
  valid_580222 = validateParameter(valid_580222, JBool, required = false,
                                 default = newJBool(true))
  if valid_580222 != nil:
    section.add "prettyPrint", valid_580222
  var valid_580223 = query.getOrDefault("oauth_token")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "oauth_token", valid_580223
  var valid_580224 = query.getOrDefault("userProject")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "userProject", valid_580224
  var valid_580225 = query.getOrDefault("alt")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = newJString("json"))
  if valid_580225 != nil:
    section.add "alt", valid_580225
  var valid_580226 = query.getOrDefault("userIp")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "userIp", valid_580226
  var valid_580227 = query.getOrDefault("quotaUser")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "quotaUser", valid_580227
  var valid_580228 = query.getOrDefault("provisionalUserProject")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "provisionalUserProject", valid_580228
  var valid_580229 = query.getOrDefault("fields")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "fields", valid_580229
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

proc call*(call_580231: Call_StorageDefaultObjectAccessControlsUpdate_580216;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a default object ACL entry on the specified bucket.
  ## 
  let valid = call_580231.validator(path, query, header, formData, body)
  let scheme = call_580231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580231.url(scheme.get, call_580231.host, call_580231.base,
                         call_580231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580231, url, valid)

proc call*(call_580232: Call_StorageDefaultObjectAccessControlsUpdate_580216;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsUpdate
  ## Updates a default object ACL entry on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580233 = newJObject()
  var query_580234 = newJObject()
  var body_580235 = newJObject()
  add(query_580234, "key", newJString(key))
  add(query_580234, "prettyPrint", newJBool(prettyPrint))
  add(query_580234, "oauth_token", newJString(oauthToken))
  add(query_580234, "userProject", newJString(userProject))
  add(query_580234, "alt", newJString(alt))
  add(query_580234, "userIp", newJString(userIp))
  add(query_580234, "quotaUser", newJString(quotaUser))
  add(path_580233, "bucket", newJString(bucket))
  if body != nil:
    body_580235 = body
  add(query_580234, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580233, "entity", newJString(entity))
  add(query_580234, "fields", newJString(fields))
  result = call_580232.call(path_580233, query_580234, nil, nil, body_580235)

var storageDefaultObjectAccessControlsUpdate* = Call_StorageDefaultObjectAccessControlsUpdate_580216(
    name: "storageDefaultObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsUpdate_580217,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsUpdate_580218,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsGet_580198 = ref object of OpenApiRestCall_579380
proc url_StorageDefaultObjectAccessControlsGet_580200(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsGet_580199(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the default object ACL entry for the specified entity on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580201 = path.getOrDefault("bucket")
  valid_580201 = validateParameter(valid_580201, JString, required = true,
                                 default = nil)
  if valid_580201 != nil:
    section.add "bucket", valid_580201
  var valid_580202 = path.getOrDefault("entity")
  valid_580202 = validateParameter(valid_580202, JString, required = true,
                                 default = nil)
  if valid_580202 != nil:
    section.add "entity", valid_580202
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580203 = query.getOrDefault("key")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "key", valid_580203
  var valid_580204 = query.getOrDefault("prettyPrint")
  valid_580204 = validateParameter(valid_580204, JBool, required = false,
                                 default = newJBool(true))
  if valid_580204 != nil:
    section.add "prettyPrint", valid_580204
  var valid_580205 = query.getOrDefault("oauth_token")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "oauth_token", valid_580205
  var valid_580206 = query.getOrDefault("userProject")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "userProject", valid_580206
  var valid_580207 = query.getOrDefault("alt")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = newJString("json"))
  if valid_580207 != nil:
    section.add "alt", valid_580207
  var valid_580208 = query.getOrDefault("userIp")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "userIp", valid_580208
  var valid_580209 = query.getOrDefault("quotaUser")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "quotaUser", valid_580209
  var valid_580210 = query.getOrDefault("provisionalUserProject")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "provisionalUserProject", valid_580210
  var valid_580211 = query.getOrDefault("fields")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "fields", valid_580211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580212: Call_StorageDefaultObjectAccessControlsGet_580198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the default object ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_580212.validator(path, query, header, formData, body)
  let scheme = call_580212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580212.url(scheme.get, call_580212.host, call_580212.base,
                         call_580212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580212, url, valid)

proc call*(call_580213: Call_StorageDefaultObjectAccessControlsGet_580198;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsGet
  ## Returns the default object ACL entry for the specified entity on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580214 = newJObject()
  var query_580215 = newJObject()
  add(query_580215, "key", newJString(key))
  add(query_580215, "prettyPrint", newJBool(prettyPrint))
  add(query_580215, "oauth_token", newJString(oauthToken))
  add(query_580215, "userProject", newJString(userProject))
  add(query_580215, "alt", newJString(alt))
  add(query_580215, "userIp", newJString(userIp))
  add(query_580215, "quotaUser", newJString(quotaUser))
  add(path_580214, "bucket", newJString(bucket))
  add(query_580215, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580214, "entity", newJString(entity))
  add(query_580215, "fields", newJString(fields))
  result = call_580213.call(path_580214, query_580215, nil, nil, nil)

var storageDefaultObjectAccessControlsGet* = Call_StorageDefaultObjectAccessControlsGet_580198(
    name: "storageDefaultObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsGet_580199,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsGet_580200,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsPatch_580254 = ref object of OpenApiRestCall_579380
proc url_StorageDefaultObjectAccessControlsPatch_580256(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsPatch_580255(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches a default object ACL entry on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580257 = path.getOrDefault("bucket")
  valid_580257 = validateParameter(valid_580257, JString, required = true,
                                 default = nil)
  if valid_580257 != nil:
    section.add "bucket", valid_580257
  var valid_580258 = path.getOrDefault("entity")
  valid_580258 = validateParameter(valid_580258, JString, required = true,
                                 default = nil)
  if valid_580258 != nil:
    section.add "entity", valid_580258
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580259 = query.getOrDefault("key")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "key", valid_580259
  var valid_580260 = query.getOrDefault("prettyPrint")
  valid_580260 = validateParameter(valid_580260, JBool, required = false,
                                 default = newJBool(true))
  if valid_580260 != nil:
    section.add "prettyPrint", valid_580260
  var valid_580261 = query.getOrDefault("oauth_token")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "oauth_token", valid_580261
  var valid_580262 = query.getOrDefault("userProject")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "userProject", valid_580262
  var valid_580263 = query.getOrDefault("alt")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = newJString("json"))
  if valid_580263 != nil:
    section.add "alt", valid_580263
  var valid_580264 = query.getOrDefault("userIp")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "userIp", valid_580264
  var valid_580265 = query.getOrDefault("quotaUser")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "quotaUser", valid_580265
  var valid_580266 = query.getOrDefault("provisionalUserProject")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "provisionalUserProject", valid_580266
  var valid_580267 = query.getOrDefault("fields")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "fields", valid_580267
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

proc call*(call_580269: Call_StorageDefaultObjectAccessControlsPatch_580254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Patches a default object ACL entry on the specified bucket.
  ## 
  let valid = call_580269.validator(path, query, header, formData, body)
  let scheme = call_580269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580269.url(scheme.get, call_580269.host, call_580269.base,
                         call_580269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580269, url, valid)

proc call*(call_580270: Call_StorageDefaultObjectAccessControlsPatch_580254;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsPatch
  ## Patches a default object ACL entry on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580271 = newJObject()
  var query_580272 = newJObject()
  var body_580273 = newJObject()
  add(query_580272, "key", newJString(key))
  add(query_580272, "prettyPrint", newJBool(prettyPrint))
  add(query_580272, "oauth_token", newJString(oauthToken))
  add(query_580272, "userProject", newJString(userProject))
  add(query_580272, "alt", newJString(alt))
  add(query_580272, "userIp", newJString(userIp))
  add(query_580272, "quotaUser", newJString(quotaUser))
  add(path_580271, "bucket", newJString(bucket))
  if body != nil:
    body_580273 = body
  add(query_580272, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580271, "entity", newJString(entity))
  add(query_580272, "fields", newJString(fields))
  result = call_580270.call(path_580271, query_580272, nil, nil, body_580273)

var storageDefaultObjectAccessControlsPatch* = Call_StorageDefaultObjectAccessControlsPatch_580254(
    name: "storageDefaultObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsPatch_580255,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsPatch_580256,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsDelete_580236 = ref object of OpenApiRestCall_579380
proc url_StorageDefaultObjectAccessControlsDelete_580238(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsDelete_580237(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580239 = path.getOrDefault("bucket")
  valid_580239 = validateParameter(valid_580239, JString, required = true,
                                 default = nil)
  if valid_580239 != nil:
    section.add "bucket", valid_580239
  var valid_580240 = path.getOrDefault("entity")
  valid_580240 = validateParameter(valid_580240, JString, required = true,
                                 default = nil)
  if valid_580240 != nil:
    section.add "entity", valid_580240
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580241 = query.getOrDefault("key")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "key", valid_580241
  var valid_580242 = query.getOrDefault("prettyPrint")
  valid_580242 = validateParameter(valid_580242, JBool, required = false,
                                 default = newJBool(true))
  if valid_580242 != nil:
    section.add "prettyPrint", valid_580242
  var valid_580243 = query.getOrDefault("oauth_token")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "oauth_token", valid_580243
  var valid_580244 = query.getOrDefault("userProject")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "userProject", valid_580244
  var valid_580245 = query.getOrDefault("alt")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = newJString("json"))
  if valid_580245 != nil:
    section.add "alt", valid_580245
  var valid_580246 = query.getOrDefault("userIp")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "userIp", valid_580246
  var valid_580247 = query.getOrDefault("quotaUser")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "quotaUser", valid_580247
  var valid_580248 = query.getOrDefault("provisionalUserProject")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "provisionalUserProject", valid_580248
  var valid_580249 = query.getOrDefault("fields")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "fields", valid_580249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580250: Call_StorageDefaultObjectAccessControlsDelete_580236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_580250.validator(path, query, header, formData, body)
  let scheme = call_580250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580250.url(scheme.get, call_580250.host, call_580250.base,
                         call_580250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580250, url, valid)

proc call*(call_580251: Call_StorageDefaultObjectAccessControlsDelete_580236;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsDelete
  ## Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580252 = newJObject()
  var query_580253 = newJObject()
  add(query_580253, "key", newJString(key))
  add(query_580253, "prettyPrint", newJBool(prettyPrint))
  add(query_580253, "oauth_token", newJString(oauthToken))
  add(query_580253, "userProject", newJString(userProject))
  add(query_580253, "alt", newJString(alt))
  add(query_580253, "userIp", newJString(userIp))
  add(query_580253, "quotaUser", newJString(quotaUser))
  add(path_580252, "bucket", newJString(bucket))
  add(query_580253, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580252, "entity", newJString(entity))
  add(query_580253, "fields", newJString(fields))
  result = call_580251.call(path_580252, query_580253, nil, nil, nil)

var storageDefaultObjectAccessControlsDelete* = Call_StorageDefaultObjectAccessControlsDelete_580236(
    name: "storageDefaultObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsDelete_580237,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsDelete_580238,
    schemes: {Scheme.Https})
type
  Call_StorageBucketsSetIamPolicy_580292 = ref object of OpenApiRestCall_579380
proc url_StorageBucketsSetIamPolicy_580294(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/iam")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketsSetIamPolicy_580293(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an IAM policy for the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580295 = path.getOrDefault("bucket")
  valid_580295 = validateParameter(valid_580295, JString, required = true,
                                 default = nil)
  if valid_580295 != nil:
    section.add "bucket", valid_580295
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580296 = query.getOrDefault("key")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "key", valid_580296
  var valid_580297 = query.getOrDefault("prettyPrint")
  valid_580297 = validateParameter(valid_580297, JBool, required = false,
                                 default = newJBool(true))
  if valid_580297 != nil:
    section.add "prettyPrint", valid_580297
  var valid_580298 = query.getOrDefault("oauth_token")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "oauth_token", valid_580298
  var valid_580299 = query.getOrDefault("userProject")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "userProject", valid_580299
  var valid_580300 = query.getOrDefault("alt")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = newJString("json"))
  if valid_580300 != nil:
    section.add "alt", valid_580300
  var valid_580301 = query.getOrDefault("userIp")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "userIp", valid_580301
  var valid_580302 = query.getOrDefault("quotaUser")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "quotaUser", valid_580302
  var valid_580303 = query.getOrDefault("provisionalUserProject")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "provisionalUserProject", valid_580303
  var valid_580304 = query.getOrDefault("fields")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "fields", valid_580304
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

proc call*(call_580306: Call_StorageBucketsSetIamPolicy_580292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an IAM policy for the specified bucket.
  ## 
  let valid = call_580306.validator(path, query, header, formData, body)
  let scheme = call_580306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580306.url(scheme.get, call_580306.host, call_580306.base,
                         call_580306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580306, url, valid)

proc call*(call_580307: Call_StorageBucketsSetIamPolicy_580292; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketsSetIamPolicy
  ## Updates an IAM policy for the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580308 = newJObject()
  var query_580309 = newJObject()
  var body_580310 = newJObject()
  add(query_580309, "key", newJString(key))
  add(query_580309, "prettyPrint", newJBool(prettyPrint))
  add(query_580309, "oauth_token", newJString(oauthToken))
  add(query_580309, "userProject", newJString(userProject))
  add(query_580309, "alt", newJString(alt))
  add(query_580309, "userIp", newJString(userIp))
  add(query_580309, "quotaUser", newJString(quotaUser))
  add(path_580308, "bucket", newJString(bucket))
  if body != nil:
    body_580310 = body
  add(query_580309, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580309, "fields", newJString(fields))
  result = call_580307.call(path_580308, query_580309, nil, nil, body_580310)

var storageBucketsSetIamPolicy* = Call_StorageBucketsSetIamPolicy_580292(
    name: "storageBucketsSetIamPolicy", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/iam",
    validator: validate_StorageBucketsSetIamPolicy_580293, base: "/storage/v1",
    url: url_StorageBucketsSetIamPolicy_580294, schemes: {Scheme.Https})
type
  Call_StorageBucketsGetIamPolicy_580274 = ref object of OpenApiRestCall_579380
proc url_StorageBucketsGetIamPolicy_580276(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/iam")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketsGetIamPolicy_580275(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns an IAM policy for the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580277 = path.getOrDefault("bucket")
  valid_580277 = validateParameter(valid_580277, JString, required = true,
                                 default = nil)
  if valid_580277 != nil:
    section.add "bucket", valid_580277
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   optionsRequestedPolicyVersion: JInt
  ##                                : The IAM policy format version to be returned. If the optionsRequestedPolicyVersion is for an older version that doesn't support part of the requested IAM policy, the request fails.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580278 = query.getOrDefault("key")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "key", valid_580278
  var valid_580279 = query.getOrDefault("prettyPrint")
  valid_580279 = validateParameter(valid_580279, JBool, required = false,
                                 default = newJBool(true))
  if valid_580279 != nil:
    section.add "prettyPrint", valid_580279
  var valid_580280 = query.getOrDefault("oauth_token")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "oauth_token", valid_580280
  var valid_580281 = query.getOrDefault("userProject")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "userProject", valid_580281
  var valid_580282 = query.getOrDefault("alt")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = newJString("json"))
  if valid_580282 != nil:
    section.add "alt", valid_580282
  var valid_580283 = query.getOrDefault("userIp")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "userIp", valid_580283
  var valid_580284 = query.getOrDefault("quotaUser")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "quotaUser", valid_580284
  var valid_580285 = query.getOrDefault("optionsRequestedPolicyVersion")
  valid_580285 = validateParameter(valid_580285, JInt, required = false, default = nil)
  if valid_580285 != nil:
    section.add "optionsRequestedPolicyVersion", valid_580285
  var valid_580286 = query.getOrDefault("provisionalUserProject")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "provisionalUserProject", valid_580286
  var valid_580287 = query.getOrDefault("fields")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "fields", valid_580287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580288: Call_StorageBucketsGetIamPolicy_580274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an IAM policy for the specified bucket.
  ## 
  let valid = call_580288.validator(path, query, header, formData, body)
  let scheme = call_580288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580288.url(scheme.get, call_580288.host, call_580288.base,
                         call_580288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580288, url, valid)

proc call*(call_580289: Call_StorageBucketsGetIamPolicy_580274; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; optionsRequestedPolicyVersion: int = 0;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketsGetIamPolicy
  ## Returns an IAM policy for the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   optionsRequestedPolicyVersion: int
  ##                                : The IAM policy format version to be returned. If the optionsRequestedPolicyVersion is for an older version that doesn't support part of the requested IAM policy, the request fails.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580290 = newJObject()
  var query_580291 = newJObject()
  add(query_580291, "key", newJString(key))
  add(query_580291, "prettyPrint", newJBool(prettyPrint))
  add(query_580291, "oauth_token", newJString(oauthToken))
  add(query_580291, "userProject", newJString(userProject))
  add(query_580291, "alt", newJString(alt))
  add(query_580291, "userIp", newJString(userIp))
  add(query_580291, "quotaUser", newJString(quotaUser))
  add(query_580291, "optionsRequestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(path_580290, "bucket", newJString(bucket))
  add(query_580291, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580291, "fields", newJString(fields))
  result = call_580289.call(path_580290, query_580291, nil, nil, nil)

var storageBucketsGetIamPolicy* = Call_StorageBucketsGetIamPolicy_580274(
    name: "storageBucketsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/iam",
    validator: validate_StorageBucketsGetIamPolicy_580275, base: "/storage/v1",
    url: url_StorageBucketsGetIamPolicy_580276, schemes: {Scheme.Https})
type
  Call_StorageBucketsTestIamPermissions_580311 = ref object of OpenApiRestCall_579380
proc url_StorageBucketsTestIamPermissions_580313(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/iam/testPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketsTestIamPermissions_580312(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Tests a set of permissions on the given bucket to see which, if any, are held by the caller.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580314 = path.getOrDefault("bucket")
  valid_580314 = validateParameter(valid_580314, JString, required = true,
                                 default = nil)
  if valid_580314 != nil:
    section.add "bucket", valid_580314
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   permissions: JArray (required)
  ##              : Permissions to test.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580315 = query.getOrDefault("key")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "key", valid_580315
  var valid_580316 = query.getOrDefault("prettyPrint")
  valid_580316 = validateParameter(valid_580316, JBool, required = false,
                                 default = newJBool(true))
  if valid_580316 != nil:
    section.add "prettyPrint", valid_580316
  var valid_580317 = query.getOrDefault("oauth_token")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "oauth_token", valid_580317
  var valid_580318 = query.getOrDefault("userProject")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "userProject", valid_580318
  assert query != nil,
        "query argument is necessary due to required `permissions` field"
  var valid_580319 = query.getOrDefault("permissions")
  valid_580319 = validateParameter(valid_580319, JArray, required = true, default = nil)
  if valid_580319 != nil:
    section.add "permissions", valid_580319
  var valid_580320 = query.getOrDefault("alt")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = newJString("json"))
  if valid_580320 != nil:
    section.add "alt", valid_580320
  var valid_580321 = query.getOrDefault("userIp")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "userIp", valid_580321
  var valid_580322 = query.getOrDefault("quotaUser")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "quotaUser", valid_580322
  var valid_580323 = query.getOrDefault("provisionalUserProject")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "provisionalUserProject", valid_580323
  var valid_580324 = query.getOrDefault("fields")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "fields", valid_580324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580325: Call_StorageBucketsTestIamPermissions_580311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests a set of permissions on the given bucket to see which, if any, are held by the caller.
  ## 
  let valid = call_580325.validator(path, query, header, formData, body)
  let scheme = call_580325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580325.url(scheme.get, call_580325.host, call_580325.base,
                         call_580325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580325, url, valid)

proc call*(call_580326: Call_StorageBucketsTestIamPermissions_580311;
          permissions: JsonNode; bucket: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketsTestIamPermissions
  ## Tests a set of permissions on the given bucket to see which, if any, are held by the caller.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   permissions: JArray (required)
  ##              : Permissions to test.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580327 = newJObject()
  var query_580328 = newJObject()
  add(query_580328, "key", newJString(key))
  add(query_580328, "prettyPrint", newJBool(prettyPrint))
  add(query_580328, "oauth_token", newJString(oauthToken))
  add(query_580328, "userProject", newJString(userProject))
  if permissions != nil:
    query_580328.add "permissions", permissions
  add(query_580328, "alt", newJString(alt))
  add(query_580328, "userIp", newJString(userIp))
  add(query_580328, "quotaUser", newJString(quotaUser))
  add(path_580327, "bucket", newJString(bucket))
  add(query_580328, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580328, "fields", newJString(fields))
  result = call_580326.call(path_580327, query_580328, nil, nil, nil)

var storageBucketsTestIamPermissions* = Call_StorageBucketsTestIamPermissions_580311(
    name: "storageBucketsTestIamPermissions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/iam/testPermissions",
    validator: validate_StorageBucketsTestIamPermissions_580312,
    base: "/storage/v1", url: url_StorageBucketsTestIamPermissions_580313,
    schemes: {Scheme.Https})
type
  Call_StorageBucketsLockRetentionPolicy_580329 = ref object of OpenApiRestCall_579380
proc url_StorageBucketsLockRetentionPolicy_580331(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/lockRetentionPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketsLockRetentionPolicy_580330(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Locks retention policy on a bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580332 = path.getOrDefault("bucket")
  valid_580332 = validateParameter(valid_580332, JString, required = true,
                                 default = nil)
  if valid_580332 != nil:
    section.add "bucket", valid_580332
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString (required)
  ##                        : Makes the operation conditional on whether bucket's current metageneration matches the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580333 = query.getOrDefault("key")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "key", valid_580333
  var valid_580334 = query.getOrDefault("prettyPrint")
  valid_580334 = validateParameter(valid_580334, JBool, required = false,
                                 default = newJBool(true))
  if valid_580334 != nil:
    section.add "prettyPrint", valid_580334
  var valid_580335 = query.getOrDefault("oauth_token")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "oauth_token", valid_580335
  var valid_580336 = query.getOrDefault("userProject")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "userProject", valid_580336
  var valid_580337 = query.getOrDefault("alt")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = newJString("json"))
  if valid_580337 != nil:
    section.add "alt", valid_580337
  var valid_580338 = query.getOrDefault("userIp")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "userIp", valid_580338
  var valid_580339 = query.getOrDefault("quotaUser")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "quotaUser", valid_580339
  assert query != nil, "query argument is necessary due to required `ifMetagenerationMatch` field"
  var valid_580340 = query.getOrDefault("ifMetagenerationMatch")
  valid_580340 = validateParameter(valid_580340, JString, required = true,
                                 default = nil)
  if valid_580340 != nil:
    section.add "ifMetagenerationMatch", valid_580340
  var valid_580341 = query.getOrDefault("provisionalUserProject")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "provisionalUserProject", valid_580341
  var valid_580342 = query.getOrDefault("fields")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "fields", valid_580342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580343: Call_StorageBucketsLockRetentionPolicy_580329;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Locks retention policy on a bucket.
  ## 
  let valid = call_580343.validator(path, query, header, formData, body)
  let scheme = call_580343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580343.url(scheme.get, call_580343.host, call_580343.base,
                         call_580343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580343, url, valid)

proc call*(call_580344: Call_StorageBucketsLockRetentionPolicy_580329;
          ifMetagenerationMatch: string; bucket: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketsLockRetentionPolicy
  ## Locks retention policy on a bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string (required)
  ##                        : Makes the operation conditional on whether bucket's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580345 = newJObject()
  var query_580346 = newJObject()
  add(query_580346, "key", newJString(key))
  add(query_580346, "prettyPrint", newJBool(prettyPrint))
  add(query_580346, "oauth_token", newJString(oauthToken))
  add(query_580346, "userProject", newJString(userProject))
  add(query_580346, "alt", newJString(alt))
  add(query_580346, "userIp", newJString(userIp))
  add(query_580346, "quotaUser", newJString(quotaUser))
  add(query_580346, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_580345, "bucket", newJString(bucket))
  add(query_580346, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580346, "fields", newJString(fields))
  result = call_580344.call(path_580345, query_580346, nil, nil, nil)

var storageBucketsLockRetentionPolicy* = Call_StorageBucketsLockRetentionPolicy_580329(
    name: "storageBucketsLockRetentionPolicy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/lockRetentionPolicy",
    validator: validate_StorageBucketsLockRetentionPolicy_580330,
    base: "/storage/v1", url: url_StorageBucketsLockRetentionPolicy_580331,
    schemes: {Scheme.Https})
type
  Call_StorageNotificationsInsert_580364 = ref object of OpenApiRestCall_579380
proc url_StorageNotificationsInsert_580366(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/notificationConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageNotificationsInsert_580365(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a notification subscription for a given bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : The parent bucket of the notification.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580367 = path.getOrDefault("bucket")
  valid_580367 = validateParameter(valid_580367, JString, required = true,
                                 default = nil)
  if valid_580367 != nil:
    section.add "bucket", valid_580367
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580368 = query.getOrDefault("key")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "key", valid_580368
  var valid_580369 = query.getOrDefault("prettyPrint")
  valid_580369 = validateParameter(valid_580369, JBool, required = false,
                                 default = newJBool(true))
  if valid_580369 != nil:
    section.add "prettyPrint", valid_580369
  var valid_580370 = query.getOrDefault("oauth_token")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "oauth_token", valid_580370
  var valid_580371 = query.getOrDefault("userProject")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "userProject", valid_580371
  var valid_580372 = query.getOrDefault("alt")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = newJString("json"))
  if valid_580372 != nil:
    section.add "alt", valid_580372
  var valid_580373 = query.getOrDefault("userIp")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "userIp", valid_580373
  var valid_580374 = query.getOrDefault("quotaUser")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "quotaUser", valid_580374
  var valid_580375 = query.getOrDefault("provisionalUserProject")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "provisionalUserProject", valid_580375
  var valid_580376 = query.getOrDefault("fields")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "fields", valid_580376
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

proc call*(call_580378: Call_StorageNotificationsInsert_580364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a notification subscription for a given bucket.
  ## 
  let valid = call_580378.validator(path, query, header, formData, body)
  let scheme = call_580378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580378.url(scheme.get, call_580378.host, call_580378.base,
                         call_580378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580378, url, valid)

proc call*(call_580379: Call_StorageNotificationsInsert_580364; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageNotificationsInsert
  ## Creates a notification subscription for a given bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : The parent bucket of the notification.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580380 = newJObject()
  var query_580381 = newJObject()
  var body_580382 = newJObject()
  add(query_580381, "key", newJString(key))
  add(query_580381, "prettyPrint", newJBool(prettyPrint))
  add(query_580381, "oauth_token", newJString(oauthToken))
  add(query_580381, "userProject", newJString(userProject))
  add(query_580381, "alt", newJString(alt))
  add(query_580381, "userIp", newJString(userIp))
  add(query_580381, "quotaUser", newJString(quotaUser))
  add(path_580380, "bucket", newJString(bucket))
  if body != nil:
    body_580382 = body
  add(query_580381, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580381, "fields", newJString(fields))
  result = call_580379.call(path_580380, query_580381, nil, nil, body_580382)

var storageNotificationsInsert* = Call_StorageNotificationsInsert_580364(
    name: "storageNotificationsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/notificationConfigs",
    validator: validate_StorageNotificationsInsert_580365, base: "/storage/v1",
    url: url_StorageNotificationsInsert_580366, schemes: {Scheme.Https})
type
  Call_StorageNotificationsList_580347 = ref object of OpenApiRestCall_579380
proc url_StorageNotificationsList_580349(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/notificationConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageNotificationsList_580348(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of notification subscriptions for a given bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a Google Cloud Storage bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580350 = path.getOrDefault("bucket")
  valid_580350 = validateParameter(valid_580350, JString, required = true,
                                 default = nil)
  if valid_580350 != nil:
    section.add "bucket", valid_580350
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580351 = query.getOrDefault("key")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "key", valid_580351
  var valid_580352 = query.getOrDefault("prettyPrint")
  valid_580352 = validateParameter(valid_580352, JBool, required = false,
                                 default = newJBool(true))
  if valid_580352 != nil:
    section.add "prettyPrint", valid_580352
  var valid_580353 = query.getOrDefault("oauth_token")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "oauth_token", valid_580353
  var valid_580354 = query.getOrDefault("userProject")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "userProject", valid_580354
  var valid_580355 = query.getOrDefault("alt")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = newJString("json"))
  if valid_580355 != nil:
    section.add "alt", valid_580355
  var valid_580356 = query.getOrDefault("userIp")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "userIp", valid_580356
  var valid_580357 = query.getOrDefault("quotaUser")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "quotaUser", valid_580357
  var valid_580358 = query.getOrDefault("provisionalUserProject")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "provisionalUserProject", valid_580358
  var valid_580359 = query.getOrDefault("fields")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "fields", valid_580359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580360: Call_StorageNotificationsList_580347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of notification subscriptions for a given bucket.
  ## 
  let valid = call_580360.validator(path, query, header, formData, body)
  let scheme = call_580360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580360.url(scheme.get, call_580360.host, call_580360.base,
                         call_580360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580360, url, valid)

proc call*(call_580361: Call_StorageNotificationsList_580347; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; provisionalUserProject: string = "";
          fields: string = ""): Recallable =
  ## storageNotificationsList
  ## Retrieves a list of notification subscriptions for a given bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a Google Cloud Storage bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580362 = newJObject()
  var query_580363 = newJObject()
  add(query_580363, "key", newJString(key))
  add(query_580363, "prettyPrint", newJBool(prettyPrint))
  add(query_580363, "oauth_token", newJString(oauthToken))
  add(query_580363, "userProject", newJString(userProject))
  add(query_580363, "alt", newJString(alt))
  add(query_580363, "userIp", newJString(userIp))
  add(query_580363, "quotaUser", newJString(quotaUser))
  add(path_580362, "bucket", newJString(bucket))
  add(query_580363, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580363, "fields", newJString(fields))
  result = call_580361.call(path_580362, query_580363, nil, nil, nil)

var storageNotificationsList* = Call_StorageNotificationsList_580347(
    name: "storageNotificationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/notificationConfigs",
    validator: validate_StorageNotificationsList_580348, base: "/storage/v1",
    url: url_StorageNotificationsList_580349, schemes: {Scheme.Https})
type
  Call_StorageNotificationsGet_580383 = ref object of OpenApiRestCall_579380
proc url_StorageNotificationsGet_580385(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "notification" in path, "`notification` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/notificationConfigs/"),
               (kind: VariableSegment, value: "notification")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageNotificationsGet_580384(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## View a notification configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   notification: JString (required)
  ##               : Notification ID
  ##   bucket: JString (required)
  ##         : The parent bucket of the notification.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `notification` field"
  var valid_580386 = path.getOrDefault("notification")
  valid_580386 = validateParameter(valid_580386, JString, required = true,
                                 default = nil)
  if valid_580386 != nil:
    section.add "notification", valid_580386
  var valid_580387 = path.getOrDefault("bucket")
  valid_580387 = validateParameter(valid_580387, JString, required = true,
                                 default = nil)
  if valid_580387 != nil:
    section.add "bucket", valid_580387
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580388 = query.getOrDefault("key")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "key", valid_580388
  var valid_580389 = query.getOrDefault("prettyPrint")
  valid_580389 = validateParameter(valid_580389, JBool, required = false,
                                 default = newJBool(true))
  if valid_580389 != nil:
    section.add "prettyPrint", valid_580389
  var valid_580390 = query.getOrDefault("oauth_token")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "oauth_token", valid_580390
  var valid_580391 = query.getOrDefault("userProject")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "userProject", valid_580391
  var valid_580392 = query.getOrDefault("alt")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = newJString("json"))
  if valid_580392 != nil:
    section.add "alt", valid_580392
  var valid_580393 = query.getOrDefault("userIp")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "userIp", valid_580393
  var valid_580394 = query.getOrDefault("quotaUser")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "quotaUser", valid_580394
  var valid_580395 = query.getOrDefault("provisionalUserProject")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "provisionalUserProject", valid_580395
  var valid_580396 = query.getOrDefault("fields")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "fields", valid_580396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580397: Call_StorageNotificationsGet_580383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## View a notification configuration.
  ## 
  let valid = call_580397.validator(path, query, header, formData, body)
  let scheme = call_580397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580397.url(scheme.get, call_580397.host, call_580397.base,
                         call_580397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580397, url, valid)

proc call*(call_580398: Call_StorageNotificationsGet_580383; notification: string;
          bucket: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageNotificationsGet
  ## View a notification configuration.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   notification: string (required)
  ##               : Notification ID
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : The parent bucket of the notification.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580399 = newJObject()
  var query_580400 = newJObject()
  add(query_580400, "key", newJString(key))
  add(query_580400, "prettyPrint", newJBool(prettyPrint))
  add(query_580400, "oauth_token", newJString(oauthToken))
  add(query_580400, "userProject", newJString(userProject))
  add(path_580399, "notification", newJString(notification))
  add(query_580400, "alt", newJString(alt))
  add(query_580400, "userIp", newJString(userIp))
  add(query_580400, "quotaUser", newJString(quotaUser))
  add(path_580399, "bucket", newJString(bucket))
  add(query_580400, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580400, "fields", newJString(fields))
  result = call_580398.call(path_580399, query_580400, nil, nil, nil)

var storageNotificationsGet* = Call_StorageNotificationsGet_580383(
    name: "storageNotificationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/b/{bucket}/notificationConfigs/{notification}",
    validator: validate_StorageNotificationsGet_580384, base: "/storage/v1",
    url: url_StorageNotificationsGet_580385, schemes: {Scheme.Https})
type
  Call_StorageNotificationsDelete_580401 = ref object of OpenApiRestCall_579380
proc url_StorageNotificationsDelete_580403(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "notification" in path, "`notification` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/notificationConfigs/"),
               (kind: VariableSegment, value: "notification")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageNotificationsDelete_580402(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes a notification subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   notification: JString (required)
  ##               : ID of the notification to delete.
  ##   bucket: JString (required)
  ##         : The parent bucket of the notification.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `notification` field"
  var valid_580404 = path.getOrDefault("notification")
  valid_580404 = validateParameter(valid_580404, JString, required = true,
                                 default = nil)
  if valid_580404 != nil:
    section.add "notification", valid_580404
  var valid_580405 = path.getOrDefault("bucket")
  valid_580405 = validateParameter(valid_580405, JString, required = true,
                                 default = nil)
  if valid_580405 != nil:
    section.add "bucket", valid_580405
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
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
  var valid_580409 = query.getOrDefault("userProject")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "userProject", valid_580409
  var valid_580410 = query.getOrDefault("alt")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = newJString("json"))
  if valid_580410 != nil:
    section.add "alt", valid_580410
  var valid_580411 = query.getOrDefault("userIp")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "userIp", valid_580411
  var valid_580412 = query.getOrDefault("quotaUser")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "quotaUser", valid_580412
  var valid_580413 = query.getOrDefault("provisionalUserProject")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "provisionalUserProject", valid_580413
  var valid_580414 = query.getOrDefault("fields")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "fields", valid_580414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580415: Call_StorageNotificationsDelete_580401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a notification subscription.
  ## 
  let valid = call_580415.validator(path, query, header, formData, body)
  let scheme = call_580415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580415.url(scheme.get, call_580415.host, call_580415.base,
                         call_580415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580415, url, valid)

proc call*(call_580416: Call_StorageNotificationsDelete_580401;
          notification: string; bucket: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageNotificationsDelete
  ## Permanently deletes a notification subscription.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   notification: string (required)
  ##               : ID of the notification to delete.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : The parent bucket of the notification.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580417 = newJObject()
  var query_580418 = newJObject()
  add(query_580418, "key", newJString(key))
  add(query_580418, "prettyPrint", newJBool(prettyPrint))
  add(query_580418, "oauth_token", newJString(oauthToken))
  add(query_580418, "userProject", newJString(userProject))
  add(path_580417, "notification", newJString(notification))
  add(query_580418, "alt", newJString(alt))
  add(query_580418, "userIp", newJString(userIp))
  add(query_580418, "quotaUser", newJString(quotaUser))
  add(path_580417, "bucket", newJString(bucket))
  add(query_580418, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580418, "fields", newJString(fields))
  result = call_580416.call(path_580417, query_580418, nil, nil, nil)

var storageNotificationsDelete* = Call_StorageNotificationsDelete_580401(
    name: "storageNotificationsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/b/{bucket}/notificationConfigs/{notification}",
    validator: validate_StorageNotificationsDelete_580402, base: "/storage/v1",
    url: url_StorageNotificationsDelete_580403, schemes: {Scheme.Https})
type
  Call_StorageObjectsInsert_580443 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsInsert_580445(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsInsert_580444(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stores a new object and metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580446 = path.getOrDefault("bucket")
  valid_580446 = validateParameter(valid_580446, JString, required = true,
                                 default = nil)
  if valid_580446 != nil:
    section.add "bucket", valid_580446
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   kmsKeyName: JString
  ##             : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  ##   name: JString
  ##       : Name of the object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this object.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   contentEncoding: JString
  ##                  : If set, sets the contentEncoding property of the final object to this value. Setting this parameter is equivalent to setting the contentEncoding metadata property. This can be useful when uploading an object with uploadType=media to indicate the encoding of the content being uploaded.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580447 = query.getOrDefault("key")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "key", valid_580447
  var valid_580448 = query.getOrDefault("prettyPrint")
  valid_580448 = validateParameter(valid_580448, JBool, required = false,
                                 default = newJBool(true))
  if valid_580448 != nil:
    section.add "prettyPrint", valid_580448
  var valid_580449 = query.getOrDefault("oauth_token")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "oauth_token", valid_580449
  var valid_580450 = query.getOrDefault("kmsKeyName")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "kmsKeyName", valid_580450
  var valid_580451 = query.getOrDefault("name")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "name", valid_580451
  var valid_580452 = query.getOrDefault("userProject")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "userProject", valid_580452
  var valid_580453 = query.getOrDefault("predefinedAcl")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_580453 != nil:
    section.add "predefinedAcl", valid_580453
  var valid_580454 = query.getOrDefault("ifGenerationMatch")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "ifGenerationMatch", valid_580454
  var valid_580455 = query.getOrDefault("ifGenerationNotMatch")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "ifGenerationNotMatch", valid_580455
  var valid_580456 = query.getOrDefault("alt")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = newJString("json"))
  if valid_580456 != nil:
    section.add "alt", valid_580456
  var valid_580457 = query.getOrDefault("userIp")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = nil)
  if valid_580457 != nil:
    section.add "userIp", valid_580457
  var valid_580458 = query.getOrDefault("quotaUser")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = nil)
  if valid_580458 != nil:
    section.add "quotaUser", valid_580458
  var valid_580459 = query.getOrDefault("ifMetagenerationMatch")
  valid_580459 = validateParameter(valid_580459, JString, required = false,
                                 default = nil)
  if valid_580459 != nil:
    section.add "ifMetagenerationMatch", valid_580459
  var valid_580460 = query.getOrDefault("contentEncoding")
  valid_580460 = validateParameter(valid_580460, JString, required = false,
                                 default = nil)
  if valid_580460 != nil:
    section.add "contentEncoding", valid_580460
  var valid_580461 = query.getOrDefault("provisionalUserProject")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = nil)
  if valid_580461 != nil:
    section.add "provisionalUserProject", valid_580461
  var valid_580462 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "ifMetagenerationNotMatch", valid_580462
  var valid_580463 = query.getOrDefault("projection")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = newJString("full"))
  if valid_580463 != nil:
    section.add "projection", valid_580463
  var valid_580464 = query.getOrDefault("fields")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "fields", valid_580464
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

proc call*(call_580466: Call_StorageObjectsInsert_580443; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stores a new object and metadata.
  ## 
  let valid = call_580466.validator(path, query, header, formData, body)
  let scheme = call_580466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580466.url(scheme.get, call_580466.host, call_580466.base,
                         call_580466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580466, url, valid)

proc call*(call_580467: Call_StorageObjectsInsert_580443; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          kmsKeyName: string = ""; name: string = ""; userProject: string = "";
          predefinedAcl: string = "authenticatedRead";
          ifGenerationMatch: string = ""; ifGenerationNotMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          contentEncoding: string = ""; provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageObjectsInsert
  ## Stores a new object and metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   kmsKeyName: string
  ##             : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  ##   name: string
  ##       : Name of the object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this object.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   body: JObject
  ##   contentEncoding: string
  ##                  : If set, sets the contentEncoding property of the final object to this value. Setting this parameter is equivalent to setting the contentEncoding metadata property. This can be useful when uploading an object with uploadType=media to indicate the encoding of the content being uploaded.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580468 = newJObject()
  var query_580469 = newJObject()
  var body_580470 = newJObject()
  add(query_580469, "key", newJString(key))
  add(query_580469, "prettyPrint", newJBool(prettyPrint))
  add(query_580469, "oauth_token", newJString(oauthToken))
  add(query_580469, "kmsKeyName", newJString(kmsKeyName))
  add(query_580469, "name", newJString(name))
  add(query_580469, "userProject", newJString(userProject))
  add(query_580469, "predefinedAcl", newJString(predefinedAcl))
  add(query_580469, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580469, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580469, "alt", newJString(alt))
  add(query_580469, "userIp", newJString(userIp))
  add(query_580469, "quotaUser", newJString(quotaUser))
  add(query_580469, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_580468, "bucket", newJString(bucket))
  if body != nil:
    body_580470 = body
  add(query_580469, "contentEncoding", newJString(contentEncoding))
  add(query_580469, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580469, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580469, "projection", newJString(projection))
  add(query_580469, "fields", newJString(fields))
  result = call_580467.call(path_580468, query_580469, nil, nil, body_580470)

var storageObjectsInsert* = Call_StorageObjectsInsert_580443(
    name: "storageObjectsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsInsert_580444, base: "/storage/v1",
    url: url_StorageObjectsInsert_580445, schemes: {Scheme.Https})
type
  Call_StorageObjectsList_580419 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsList_580421(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsList_580420(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a list of objects matching the criteria.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which to look for objects.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580422 = path.getOrDefault("bucket")
  valid_580422 = validateParameter(valid_580422, JString, required = true,
                                 default = nil)
  if valid_580422 != nil:
    section.add "bucket", valid_580422
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   prefix: JString
  ##         : Filter results to objects whose names begin with this prefix.
  ##   includeTrailingDelimiter: JBool
  ##                           : If true, objects that end in exactly one instance of delimiter will have their metadata included in items in addition to prefixes.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: JString
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   maxResults: JInt
  ##             : Maximum number of items plus prefixes to return in a single page of responses. As duplicate prefixes are omitted, fewer total results may be returned than requested. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   versions: JBool
  ##           : If true, lists all versions of an object as distinct results. The default is false. For more information, see Object Versioning.
  section = newJObject()
  var valid_580423 = query.getOrDefault("key")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "key", valid_580423
  var valid_580424 = query.getOrDefault("prettyPrint")
  valid_580424 = validateParameter(valid_580424, JBool, required = false,
                                 default = newJBool(true))
  if valid_580424 != nil:
    section.add "prettyPrint", valid_580424
  var valid_580425 = query.getOrDefault("oauth_token")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "oauth_token", valid_580425
  var valid_580426 = query.getOrDefault("prefix")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = nil)
  if valid_580426 != nil:
    section.add "prefix", valid_580426
  var valid_580427 = query.getOrDefault("includeTrailingDelimiter")
  valid_580427 = validateParameter(valid_580427, JBool, required = false, default = nil)
  if valid_580427 != nil:
    section.add "includeTrailingDelimiter", valid_580427
  var valid_580428 = query.getOrDefault("userProject")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "userProject", valid_580428
  var valid_580429 = query.getOrDefault("alt")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = newJString("json"))
  if valid_580429 != nil:
    section.add "alt", valid_580429
  var valid_580430 = query.getOrDefault("userIp")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "userIp", valid_580430
  var valid_580431 = query.getOrDefault("quotaUser")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "quotaUser", valid_580431
  var valid_580432 = query.getOrDefault("pageToken")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "pageToken", valid_580432
  var valid_580433 = query.getOrDefault("provisionalUserProject")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "provisionalUserProject", valid_580433
  var valid_580434 = query.getOrDefault("projection")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = newJString("full"))
  if valid_580434 != nil:
    section.add "projection", valid_580434
  var valid_580435 = query.getOrDefault("fields")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "fields", valid_580435
  var valid_580436 = query.getOrDefault("delimiter")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "delimiter", valid_580436
  var valid_580437 = query.getOrDefault("maxResults")
  valid_580437 = validateParameter(valid_580437, JInt, required = false,
                                 default = newJInt(1000))
  if valid_580437 != nil:
    section.add "maxResults", valid_580437
  var valid_580438 = query.getOrDefault("versions")
  valid_580438 = validateParameter(valid_580438, JBool, required = false, default = nil)
  if valid_580438 != nil:
    section.add "versions", valid_580438
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580439: Call_StorageObjectsList_580419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of objects matching the criteria.
  ## 
  let valid = call_580439.validator(path, query, header, formData, body)
  let scheme = call_580439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580439.url(scheme.get, call_580439.host, call_580439.base,
                         call_580439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580439, url, valid)

proc call*(call_580440: Call_StorageObjectsList_580419; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          prefix: string = ""; includeTrailingDelimiter: bool = false;
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = "";
          provisionalUserProject: string = ""; projection: string = "full";
          fields: string = ""; delimiter: string = ""; maxResults: int = 1000;
          versions: bool = false): Recallable =
  ## storageObjectsList
  ## Retrieves a list of objects matching the criteria.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   prefix: string
  ##         : Filter results to objects whose names begin with this prefix.
  ##   includeTrailingDelimiter: bool
  ##                           : If true, objects that end in exactly one instance of delimiter will have their metadata included in items in addition to prefixes.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   bucket: string (required)
  ##         : Name of the bucket in which to look for objects.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: string
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   maxResults: int
  ##             : Maximum number of items plus prefixes to return in a single page of responses. As duplicate prefixes are omitted, fewer total results may be returned than requested. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   versions: bool
  ##           : If true, lists all versions of an object as distinct results. The default is false. For more information, see Object Versioning.
  var path_580441 = newJObject()
  var query_580442 = newJObject()
  add(query_580442, "key", newJString(key))
  add(query_580442, "prettyPrint", newJBool(prettyPrint))
  add(query_580442, "oauth_token", newJString(oauthToken))
  add(query_580442, "prefix", newJString(prefix))
  add(query_580442, "includeTrailingDelimiter", newJBool(includeTrailingDelimiter))
  add(query_580442, "userProject", newJString(userProject))
  add(query_580442, "alt", newJString(alt))
  add(query_580442, "userIp", newJString(userIp))
  add(query_580442, "quotaUser", newJString(quotaUser))
  add(query_580442, "pageToken", newJString(pageToken))
  add(path_580441, "bucket", newJString(bucket))
  add(query_580442, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580442, "projection", newJString(projection))
  add(query_580442, "fields", newJString(fields))
  add(query_580442, "delimiter", newJString(delimiter))
  add(query_580442, "maxResults", newJInt(maxResults))
  add(query_580442, "versions", newJBool(versions))
  result = call_580440.call(path_580441, query_580442, nil, nil, nil)

var storageObjectsList* = Call_StorageObjectsList_580419(
    name: "storageObjectsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsList_580420, base: "/storage/v1",
    url: url_StorageObjectsList_580421, schemes: {Scheme.Https})
type
  Call_StorageObjectsWatchAll_580471 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsWatchAll_580473(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/watch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsWatchAll_580472(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Watch for changes on all objects in a bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which to look for objects.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580474 = path.getOrDefault("bucket")
  valid_580474 = validateParameter(valid_580474, JString, required = true,
                                 default = nil)
  if valid_580474 != nil:
    section.add "bucket", valid_580474
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   prefix: JString
  ##         : Filter results to objects whose names begin with this prefix.
  ##   includeTrailingDelimiter: JBool
  ##                           : If true, objects that end in exactly one instance of delimiter will have their metadata included in items in addition to prefixes.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: JString
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   maxResults: JInt
  ##             : Maximum number of items plus prefixes to return in a single page of responses. As duplicate prefixes are omitted, fewer total results may be returned than requested. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   versions: JBool
  ##           : If true, lists all versions of an object as distinct results. The default is false. For more information, see Object Versioning.
  section = newJObject()
  var valid_580475 = query.getOrDefault("key")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = nil)
  if valid_580475 != nil:
    section.add "key", valid_580475
  var valid_580476 = query.getOrDefault("prettyPrint")
  valid_580476 = validateParameter(valid_580476, JBool, required = false,
                                 default = newJBool(true))
  if valid_580476 != nil:
    section.add "prettyPrint", valid_580476
  var valid_580477 = query.getOrDefault("oauth_token")
  valid_580477 = validateParameter(valid_580477, JString, required = false,
                                 default = nil)
  if valid_580477 != nil:
    section.add "oauth_token", valid_580477
  var valid_580478 = query.getOrDefault("prefix")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = nil)
  if valid_580478 != nil:
    section.add "prefix", valid_580478
  var valid_580479 = query.getOrDefault("includeTrailingDelimiter")
  valid_580479 = validateParameter(valid_580479, JBool, required = false, default = nil)
  if valid_580479 != nil:
    section.add "includeTrailingDelimiter", valid_580479
  var valid_580480 = query.getOrDefault("userProject")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = nil)
  if valid_580480 != nil:
    section.add "userProject", valid_580480
  var valid_580481 = query.getOrDefault("alt")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = newJString("json"))
  if valid_580481 != nil:
    section.add "alt", valid_580481
  var valid_580482 = query.getOrDefault("userIp")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = nil)
  if valid_580482 != nil:
    section.add "userIp", valid_580482
  var valid_580483 = query.getOrDefault("quotaUser")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "quotaUser", valid_580483
  var valid_580484 = query.getOrDefault("pageToken")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "pageToken", valid_580484
  var valid_580485 = query.getOrDefault("provisionalUserProject")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "provisionalUserProject", valid_580485
  var valid_580486 = query.getOrDefault("projection")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = newJString("full"))
  if valid_580486 != nil:
    section.add "projection", valid_580486
  var valid_580487 = query.getOrDefault("fields")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "fields", valid_580487
  var valid_580488 = query.getOrDefault("delimiter")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "delimiter", valid_580488
  var valid_580489 = query.getOrDefault("maxResults")
  valid_580489 = validateParameter(valid_580489, JInt, required = false,
                                 default = newJInt(1000))
  if valid_580489 != nil:
    section.add "maxResults", valid_580489
  var valid_580490 = query.getOrDefault("versions")
  valid_580490 = validateParameter(valid_580490, JBool, required = false, default = nil)
  if valid_580490 != nil:
    section.add "versions", valid_580490
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resource: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580492: Call_StorageObjectsWatchAll_580471; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes on all objects in a bucket.
  ## 
  let valid = call_580492.validator(path, query, header, formData, body)
  let scheme = call_580492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580492.url(scheme.get, call_580492.host, call_580492.base,
                         call_580492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580492, url, valid)

proc call*(call_580493: Call_StorageObjectsWatchAll_580471; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          prefix: string = ""; includeTrailingDelimiter: bool = false;
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = "";
          provisionalUserProject: string = ""; resource: JsonNode = nil;
          projection: string = "full"; fields: string = ""; delimiter: string = "";
          maxResults: int = 1000; versions: bool = false): Recallable =
  ## storageObjectsWatchAll
  ## Watch for changes on all objects in a bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   prefix: string
  ##         : Filter results to objects whose names begin with this prefix.
  ##   includeTrailingDelimiter: bool
  ##                           : If true, objects that end in exactly one instance of delimiter will have their metadata included in items in addition to prefixes.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   bucket: string (required)
  ##         : Name of the bucket in which to look for objects.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   resource: JObject
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: string
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   maxResults: int
  ##             : Maximum number of items plus prefixes to return in a single page of responses. As duplicate prefixes are omitted, fewer total results may be returned than requested. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   versions: bool
  ##           : If true, lists all versions of an object as distinct results. The default is false. For more information, see Object Versioning.
  var path_580494 = newJObject()
  var query_580495 = newJObject()
  var body_580496 = newJObject()
  add(query_580495, "key", newJString(key))
  add(query_580495, "prettyPrint", newJBool(prettyPrint))
  add(query_580495, "oauth_token", newJString(oauthToken))
  add(query_580495, "prefix", newJString(prefix))
  add(query_580495, "includeTrailingDelimiter", newJBool(includeTrailingDelimiter))
  add(query_580495, "userProject", newJString(userProject))
  add(query_580495, "alt", newJString(alt))
  add(query_580495, "userIp", newJString(userIp))
  add(query_580495, "quotaUser", newJString(quotaUser))
  add(query_580495, "pageToken", newJString(pageToken))
  add(path_580494, "bucket", newJString(bucket))
  add(query_580495, "provisionalUserProject", newJString(provisionalUserProject))
  if resource != nil:
    body_580496 = resource
  add(query_580495, "projection", newJString(projection))
  add(query_580495, "fields", newJString(fields))
  add(query_580495, "delimiter", newJString(delimiter))
  add(query_580495, "maxResults", newJInt(maxResults))
  add(query_580495, "versions", newJBool(versions))
  result = call_580493.call(path_580494, query_580495, nil, nil, body_580496)

var storageObjectsWatchAll* = Call_StorageObjectsWatchAll_580471(
    name: "storageObjectsWatchAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/o/watch",
    validator: validate_StorageObjectsWatchAll_580472, base: "/storage/v1",
    url: url_StorageObjectsWatchAll_580473, schemes: {Scheme.Https})
type
  Call_StorageObjectsUpdate_580521 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsUpdate_580523(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsUpdate_580522(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an object's metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580524 = path.getOrDefault("bucket")
  valid_580524 = validateParameter(valid_580524, JString, required = true,
                                 default = nil)
  if valid_580524 != nil:
    section.add "bucket", valid_580524
  var valid_580525 = path.getOrDefault("object")
  valid_580525 = validateParameter(valid_580525, JString, required = true,
                                 default = nil)
  if valid_580525 != nil:
    section.add "object", valid_580525
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this object.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580526 = query.getOrDefault("key")
  valid_580526 = validateParameter(valid_580526, JString, required = false,
                                 default = nil)
  if valid_580526 != nil:
    section.add "key", valid_580526
  var valid_580527 = query.getOrDefault("prettyPrint")
  valid_580527 = validateParameter(valid_580527, JBool, required = false,
                                 default = newJBool(true))
  if valid_580527 != nil:
    section.add "prettyPrint", valid_580527
  var valid_580528 = query.getOrDefault("oauth_token")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = nil)
  if valid_580528 != nil:
    section.add "oauth_token", valid_580528
  var valid_580529 = query.getOrDefault("generation")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "generation", valid_580529
  var valid_580530 = query.getOrDefault("userProject")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "userProject", valid_580530
  var valid_580531 = query.getOrDefault("predefinedAcl")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_580531 != nil:
    section.add "predefinedAcl", valid_580531
  var valid_580532 = query.getOrDefault("ifGenerationMatch")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "ifGenerationMatch", valid_580532
  var valid_580533 = query.getOrDefault("ifGenerationNotMatch")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "ifGenerationNotMatch", valid_580533
  var valid_580534 = query.getOrDefault("alt")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = newJString("json"))
  if valid_580534 != nil:
    section.add "alt", valid_580534
  var valid_580535 = query.getOrDefault("userIp")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "userIp", valid_580535
  var valid_580536 = query.getOrDefault("quotaUser")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "quotaUser", valid_580536
  var valid_580537 = query.getOrDefault("ifMetagenerationMatch")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "ifMetagenerationMatch", valid_580537
  var valid_580538 = query.getOrDefault("provisionalUserProject")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "provisionalUserProject", valid_580538
  var valid_580539 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = nil)
  if valid_580539 != nil:
    section.add "ifMetagenerationNotMatch", valid_580539
  var valid_580540 = query.getOrDefault("projection")
  valid_580540 = validateParameter(valid_580540, JString, required = false,
                                 default = newJString("full"))
  if valid_580540 != nil:
    section.add "projection", valid_580540
  var valid_580541 = query.getOrDefault("fields")
  valid_580541 = validateParameter(valid_580541, JString, required = false,
                                 default = nil)
  if valid_580541 != nil:
    section.add "fields", valid_580541
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

proc call*(call_580543: Call_StorageObjectsUpdate_580521; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an object's metadata.
  ## 
  let valid = call_580543.validator(path, query, header, formData, body)
  let scheme = call_580543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580543.url(scheme.get, call_580543.host, call_580543.base,
                         call_580543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580543, url, valid)

proc call*(call_580544: Call_StorageObjectsUpdate_580521; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; userProject: string = "";
          predefinedAcl: string = "authenticatedRead";
          ifGenerationMatch: string = ""; ifGenerationNotMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageObjectsUpdate
  ## Updates an object's metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this object.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580545 = newJObject()
  var query_580546 = newJObject()
  var body_580547 = newJObject()
  add(query_580546, "key", newJString(key))
  add(query_580546, "prettyPrint", newJBool(prettyPrint))
  add(query_580546, "oauth_token", newJString(oauthToken))
  add(query_580546, "generation", newJString(generation))
  add(query_580546, "userProject", newJString(userProject))
  add(query_580546, "predefinedAcl", newJString(predefinedAcl))
  add(query_580546, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580546, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580546, "alt", newJString(alt))
  add(query_580546, "userIp", newJString(userIp))
  add(query_580546, "quotaUser", newJString(quotaUser))
  add(query_580546, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_580545, "bucket", newJString(bucket))
  if body != nil:
    body_580547 = body
  add(query_580546, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580545, "object", newJString(`object`))
  add(query_580546, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580546, "projection", newJString(projection))
  add(query_580546, "fields", newJString(fields))
  result = call_580544.call(path_580545, query_580546, nil, nil, body_580547)

var storageObjectsUpdate* = Call_StorageObjectsUpdate_580521(
    name: "storageObjectsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsUpdate_580522, base: "/storage/v1",
    url: url_StorageObjectsUpdate_580523, schemes: {Scheme.Https})
type
  Call_StorageObjectsGet_580497 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsGet_580499(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsGet_580498(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves an object or its metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580500 = path.getOrDefault("bucket")
  valid_580500 = validateParameter(valid_580500, JString, required = true,
                                 default = nil)
  if valid_580500 != nil:
    section.add "bucket", valid_580500
  var valid_580501 = path.getOrDefault("object")
  valid_580501 = validateParameter(valid_580501, JString, required = true,
                                 default = nil)
  if valid_580501 != nil:
    section.add "object", valid_580501
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580502 = query.getOrDefault("key")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "key", valid_580502
  var valid_580503 = query.getOrDefault("prettyPrint")
  valid_580503 = validateParameter(valid_580503, JBool, required = false,
                                 default = newJBool(true))
  if valid_580503 != nil:
    section.add "prettyPrint", valid_580503
  var valid_580504 = query.getOrDefault("oauth_token")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "oauth_token", valid_580504
  var valid_580505 = query.getOrDefault("generation")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = nil)
  if valid_580505 != nil:
    section.add "generation", valid_580505
  var valid_580506 = query.getOrDefault("userProject")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = nil)
  if valid_580506 != nil:
    section.add "userProject", valid_580506
  var valid_580507 = query.getOrDefault("ifGenerationMatch")
  valid_580507 = validateParameter(valid_580507, JString, required = false,
                                 default = nil)
  if valid_580507 != nil:
    section.add "ifGenerationMatch", valid_580507
  var valid_580508 = query.getOrDefault("ifGenerationNotMatch")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "ifGenerationNotMatch", valid_580508
  var valid_580509 = query.getOrDefault("alt")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = newJString("json"))
  if valid_580509 != nil:
    section.add "alt", valid_580509
  var valid_580510 = query.getOrDefault("userIp")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "userIp", valid_580510
  var valid_580511 = query.getOrDefault("quotaUser")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = nil)
  if valid_580511 != nil:
    section.add "quotaUser", valid_580511
  var valid_580512 = query.getOrDefault("ifMetagenerationMatch")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = nil)
  if valid_580512 != nil:
    section.add "ifMetagenerationMatch", valid_580512
  var valid_580513 = query.getOrDefault("provisionalUserProject")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "provisionalUserProject", valid_580513
  var valid_580514 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "ifMetagenerationNotMatch", valid_580514
  var valid_580515 = query.getOrDefault("projection")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = newJString("full"))
  if valid_580515 != nil:
    section.add "projection", valid_580515
  var valid_580516 = query.getOrDefault("fields")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "fields", valid_580516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580517: Call_StorageObjectsGet_580497; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an object or its metadata.
  ## 
  let valid = call_580517.validator(path, query, header, formData, body)
  let scheme = call_580517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580517.url(scheme.get, call_580517.host, call_580517.base,
                         call_580517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580517, url, valid)

proc call*(call_580518: Call_StorageObjectsGet_580497; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; userProject: string = "";
          ifGenerationMatch: string = ""; ifGenerationNotMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageObjectsGet
  ## Retrieves an object or its metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580519 = newJObject()
  var query_580520 = newJObject()
  add(query_580520, "key", newJString(key))
  add(query_580520, "prettyPrint", newJBool(prettyPrint))
  add(query_580520, "oauth_token", newJString(oauthToken))
  add(query_580520, "generation", newJString(generation))
  add(query_580520, "userProject", newJString(userProject))
  add(query_580520, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580520, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580520, "alt", newJString(alt))
  add(query_580520, "userIp", newJString(userIp))
  add(query_580520, "quotaUser", newJString(quotaUser))
  add(query_580520, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_580519, "bucket", newJString(bucket))
  add(query_580520, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580519, "object", newJString(`object`))
  add(query_580520, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580520, "projection", newJString(projection))
  add(query_580520, "fields", newJString(fields))
  result = call_580518.call(path_580519, query_580520, nil, nil, nil)

var storageObjectsGet* = Call_StorageObjectsGet_580497(name: "storageObjectsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/b/{bucket}/o/{object}", validator: validate_StorageObjectsGet_580498,
    base: "/storage/v1", url: url_StorageObjectsGet_580499, schemes: {Scheme.Https})
type
  Call_StorageObjectsPatch_580571 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsPatch_580573(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsPatch_580572(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Patches an object's metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580574 = path.getOrDefault("bucket")
  valid_580574 = validateParameter(valid_580574, JString, required = true,
                                 default = nil)
  if valid_580574 != nil:
    section.add "bucket", valid_580574
  var valid_580575 = path.getOrDefault("object")
  valid_580575 = validateParameter(valid_580575, JString, required = true,
                                 default = nil)
  if valid_580575 != nil:
    section.add "object", valid_580575
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: JString
  ##              : The project to be billed for this request, for Requester Pays buckets.
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this object.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580576 = query.getOrDefault("key")
  valid_580576 = validateParameter(valid_580576, JString, required = false,
                                 default = nil)
  if valid_580576 != nil:
    section.add "key", valid_580576
  var valid_580577 = query.getOrDefault("prettyPrint")
  valid_580577 = validateParameter(valid_580577, JBool, required = false,
                                 default = newJBool(true))
  if valid_580577 != nil:
    section.add "prettyPrint", valid_580577
  var valid_580578 = query.getOrDefault("oauth_token")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "oauth_token", valid_580578
  var valid_580579 = query.getOrDefault("generation")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = nil)
  if valid_580579 != nil:
    section.add "generation", valid_580579
  var valid_580580 = query.getOrDefault("userProject")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = nil)
  if valid_580580 != nil:
    section.add "userProject", valid_580580
  var valid_580581 = query.getOrDefault("predefinedAcl")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_580581 != nil:
    section.add "predefinedAcl", valid_580581
  var valid_580582 = query.getOrDefault("ifGenerationMatch")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "ifGenerationMatch", valid_580582
  var valid_580583 = query.getOrDefault("ifGenerationNotMatch")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "ifGenerationNotMatch", valid_580583
  var valid_580584 = query.getOrDefault("alt")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = newJString("json"))
  if valid_580584 != nil:
    section.add "alt", valid_580584
  var valid_580585 = query.getOrDefault("userIp")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = nil)
  if valid_580585 != nil:
    section.add "userIp", valid_580585
  var valid_580586 = query.getOrDefault("quotaUser")
  valid_580586 = validateParameter(valid_580586, JString, required = false,
                                 default = nil)
  if valid_580586 != nil:
    section.add "quotaUser", valid_580586
  var valid_580587 = query.getOrDefault("ifMetagenerationMatch")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = nil)
  if valid_580587 != nil:
    section.add "ifMetagenerationMatch", valid_580587
  var valid_580588 = query.getOrDefault("provisionalUserProject")
  valid_580588 = validateParameter(valid_580588, JString, required = false,
                                 default = nil)
  if valid_580588 != nil:
    section.add "provisionalUserProject", valid_580588
  var valid_580589 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = nil)
  if valid_580589 != nil:
    section.add "ifMetagenerationNotMatch", valid_580589
  var valid_580590 = query.getOrDefault("projection")
  valid_580590 = validateParameter(valid_580590, JString, required = false,
                                 default = newJString("full"))
  if valid_580590 != nil:
    section.add "projection", valid_580590
  var valid_580591 = query.getOrDefault("fields")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = nil)
  if valid_580591 != nil:
    section.add "fields", valid_580591
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

proc call*(call_580593: Call_StorageObjectsPatch_580571; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches an object's metadata.
  ## 
  let valid = call_580593.validator(path, query, header, formData, body)
  let scheme = call_580593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580593.url(scheme.get, call_580593.host, call_580593.base,
                         call_580593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580593, url, valid)

proc call*(call_580594: Call_StorageObjectsPatch_580571; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; userProject: string = "";
          predefinedAcl: string = "authenticatedRead";
          ifGenerationMatch: string = ""; ifGenerationNotMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageObjectsPatch
  ## Patches an object's metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request, for Requester Pays buckets.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this object.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580595 = newJObject()
  var query_580596 = newJObject()
  var body_580597 = newJObject()
  add(query_580596, "key", newJString(key))
  add(query_580596, "prettyPrint", newJBool(prettyPrint))
  add(query_580596, "oauth_token", newJString(oauthToken))
  add(query_580596, "generation", newJString(generation))
  add(query_580596, "userProject", newJString(userProject))
  add(query_580596, "predefinedAcl", newJString(predefinedAcl))
  add(query_580596, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580596, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580596, "alt", newJString(alt))
  add(query_580596, "userIp", newJString(userIp))
  add(query_580596, "quotaUser", newJString(quotaUser))
  add(query_580596, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_580595, "bucket", newJString(bucket))
  if body != nil:
    body_580597 = body
  add(query_580596, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580595, "object", newJString(`object`))
  add(query_580596, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580596, "projection", newJString(projection))
  add(query_580596, "fields", newJString(fields))
  result = call_580594.call(path_580595, query_580596, nil, nil, body_580597)

var storageObjectsPatch* = Call_StorageObjectsPatch_580571(
    name: "storageObjectsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsPatch_580572, base: "/storage/v1",
    url: url_StorageObjectsPatch_580573, schemes: {Scheme.Https})
type
  Call_StorageObjectsDelete_580548 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsDelete_580550(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsDelete_580549(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an object and its metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580551 = path.getOrDefault("bucket")
  valid_580551 = validateParameter(valid_580551, JString, required = true,
                                 default = nil)
  if valid_580551 != nil:
    section.add "bucket", valid_580551
  var valid_580552 = path.getOrDefault("object")
  valid_580552 = validateParameter(valid_580552, JString, required = true,
                                 default = nil)
  if valid_580552 != nil:
    section.add "object", valid_580552
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, permanently deletes a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580553 = query.getOrDefault("key")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = nil)
  if valid_580553 != nil:
    section.add "key", valid_580553
  var valid_580554 = query.getOrDefault("prettyPrint")
  valid_580554 = validateParameter(valid_580554, JBool, required = false,
                                 default = newJBool(true))
  if valid_580554 != nil:
    section.add "prettyPrint", valid_580554
  var valid_580555 = query.getOrDefault("oauth_token")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "oauth_token", valid_580555
  var valid_580556 = query.getOrDefault("generation")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = nil)
  if valid_580556 != nil:
    section.add "generation", valid_580556
  var valid_580557 = query.getOrDefault("userProject")
  valid_580557 = validateParameter(valid_580557, JString, required = false,
                                 default = nil)
  if valid_580557 != nil:
    section.add "userProject", valid_580557
  var valid_580558 = query.getOrDefault("ifGenerationMatch")
  valid_580558 = validateParameter(valid_580558, JString, required = false,
                                 default = nil)
  if valid_580558 != nil:
    section.add "ifGenerationMatch", valid_580558
  var valid_580559 = query.getOrDefault("ifGenerationNotMatch")
  valid_580559 = validateParameter(valid_580559, JString, required = false,
                                 default = nil)
  if valid_580559 != nil:
    section.add "ifGenerationNotMatch", valid_580559
  var valid_580560 = query.getOrDefault("alt")
  valid_580560 = validateParameter(valid_580560, JString, required = false,
                                 default = newJString("json"))
  if valid_580560 != nil:
    section.add "alt", valid_580560
  var valid_580561 = query.getOrDefault("userIp")
  valid_580561 = validateParameter(valid_580561, JString, required = false,
                                 default = nil)
  if valid_580561 != nil:
    section.add "userIp", valid_580561
  var valid_580562 = query.getOrDefault("quotaUser")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = nil)
  if valid_580562 != nil:
    section.add "quotaUser", valid_580562
  var valid_580563 = query.getOrDefault("ifMetagenerationMatch")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = nil)
  if valid_580563 != nil:
    section.add "ifMetagenerationMatch", valid_580563
  var valid_580564 = query.getOrDefault("provisionalUserProject")
  valid_580564 = validateParameter(valid_580564, JString, required = false,
                                 default = nil)
  if valid_580564 != nil:
    section.add "provisionalUserProject", valid_580564
  var valid_580565 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "ifMetagenerationNotMatch", valid_580565
  var valid_580566 = query.getOrDefault("fields")
  valid_580566 = validateParameter(valid_580566, JString, required = false,
                                 default = nil)
  if valid_580566 != nil:
    section.add "fields", valid_580566
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580567: Call_StorageObjectsDelete_580548; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an object and its metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ## 
  let valid = call_580567.validator(path, query, header, formData, body)
  let scheme = call_580567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580567.url(scheme.get, call_580567.host, call_580567.base,
                         call_580567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580567, url, valid)

proc call*(call_580568: Call_StorageObjectsDelete_580548; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; userProject: string = "";
          ifGenerationMatch: string = ""; ifGenerationNotMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; fields: string = ""): Recallable =
  ## storageObjectsDelete
  ## Deletes an object and its metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, permanently deletes a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580569 = newJObject()
  var query_580570 = newJObject()
  add(query_580570, "key", newJString(key))
  add(query_580570, "prettyPrint", newJBool(prettyPrint))
  add(query_580570, "oauth_token", newJString(oauthToken))
  add(query_580570, "generation", newJString(generation))
  add(query_580570, "userProject", newJString(userProject))
  add(query_580570, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580570, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580570, "alt", newJString(alt))
  add(query_580570, "userIp", newJString(userIp))
  add(query_580570, "quotaUser", newJString(quotaUser))
  add(query_580570, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_580569, "bucket", newJString(bucket))
  add(query_580570, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580569, "object", newJString(`object`))
  add(query_580570, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580570, "fields", newJString(fields))
  result = call_580568.call(path_580569, query_580570, nil, nil, nil)

var storageObjectsDelete* = Call_StorageObjectsDelete_580548(
    name: "storageObjectsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsDelete_580549, base: "/storage/v1",
    url: url_StorageObjectsDelete_580550, schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsInsert_580617 = ref object of OpenApiRestCall_579380
proc url_StorageObjectAccessControlsInsert_580619(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsInsert_580618(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new ACL entry on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580620 = path.getOrDefault("bucket")
  valid_580620 = validateParameter(valid_580620, JString, required = true,
                                 default = nil)
  if valid_580620 != nil:
    section.add "bucket", valid_580620
  var valid_580621 = path.getOrDefault("object")
  valid_580621 = validateParameter(valid_580621, JString, required = true,
                                 default = nil)
  if valid_580621 != nil:
    section.add "object", valid_580621
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580622 = query.getOrDefault("key")
  valid_580622 = validateParameter(valid_580622, JString, required = false,
                                 default = nil)
  if valid_580622 != nil:
    section.add "key", valid_580622
  var valid_580623 = query.getOrDefault("prettyPrint")
  valid_580623 = validateParameter(valid_580623, JBool, required = false,
                                 default = newJBool(true))
  if valid_580623 != nil:
    section.add "prettyPrint", valid_580623
  var valid_580624 = query.getOrDefault("oauth_token")
  valid_580624 = validateParameter(valid_580624, JString, required = false,
                                 default = nil)
  if valid_580624 != nil:
    section.add "oauth_token", valid_580624
  var valid_580625 = query.getOrDefault("generation")
  valid_580625 = validateParameter(valid_580625, JString, required = false,
                                 default = nil)
  if valid_580625 != nil:
    section.add "generation", valid_580625
  var valid_580626 = query.getOrDefault("userProject")
  valid_580626 = validateParameter(valid_580626, JString, required = false,
                                 default = nil)
  if valid_580626 != nil:
    section.add "userProject", valid_580626
  var valid_580627 = query.getOrDefault("alt")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = newJString("json"))
  if valid_580627 != nil:
    section.add "alt", valid_580627
  var valid_580628 = query.getOrDefault("userIp")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = nil)
  if valid_580628 != nil:
    section.add "userIp", valid_580628
  var valid_580629 = query.getOrDefault("quotaUser")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "quotaUser", valid_580629
  var valid_580630 = query.getOrDefault("provisionalUserProject")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = nil)
  if valid_580630 != nil:
    section.add "provisionalUserProject", valid_580630
  var valid_580631 = query.getOrDefault("fields")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = nil)
  if valid_580631 != nil:
    section.add "fields", valid_580631
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

proc call*(call_580633: Call_StorageObjectAccessControlsInsert_580617;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified object.
  ## 
  let valid = call_580633.validator(path, query, header, formData, body)
  let scheme = call_580633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580633.url(scheme.get, call_580633.host, call_580633.base,
                         call_580633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580633, url, valid)

proc call*(call_580634: Call_StorageObjectAccessControlsInsert_580617;
          bucket: string; `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageObjectAccessControlsInsert
  ## Creates a new ACL entry on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580635 = newJObject()
  var query_580636 = newJObject()
  var body_580637 = newJObject()
  add(query_580636, "key", newJString(key))
  add(query_580636, "prettyPrint", newJBool(prettyPrint))
  add(query_580636, "oauth_token", newJString(oauthToken))
  add(query_580636, "generation", newJString(generation))
  add(query_580636, "userProject", newJString(userProject))
  add(query_580636, "alt", newJString(alt))
  add(query_580636, "userIp", newJString(userIp))
  add(query_580636, "quotaUser", newJString(quotaUser))
  add(path_580635, "bucket", newJString(bucket))
  if body != nil:
    body_580637 = body
  add(query_580636, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580635, "object", newJString(`object`))
  add(query_580636, "fields", newJString(fields))
  result = call_580634.call(path_580635, query_580636, nil, nil, body_580637)

var storageObjectAccessControlsInsert* = Call_StorageObjectAccessControlsInsert_580617(
    name: "storageObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsInsert_580618,
    base: "/storage/v1", url: url_StorageObjectAccessControlsInsert_580619,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsList_580598 = ref object of OpenApiRestCall_579380
proc url_StorageObjectAccessControlsList_580600(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsList_580599(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves ACL entries on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580601 = path.getOrDefault("bucket")
  valid_580601 = validateParameter(valid_580601, JString, required = true,
                                 default = nil)
  if valid_580601 != nil:
    section.add "bucket", valid_580601
  var valid_580602 = path.getOrDefault("object")
  valid_580602 = validateParameter(valid_580602, JString, required = true,
                                 default = nil)
  if valid_580602 != nil:
    section.add "object", valid_580602
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580603 = query.getOrDefault("key")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = nil)
  if valid_580603 != nil:
    section.add "key", valid_580603
  var valid_580604 = query.getOrDefault("prettyPrint")
  valid_580604 = validateParameter(valid_580604, JBool, required = false,
                                 default = newJBool(true))
  if valid_580604 != nil:
    section.add "prettyPrint", valid_580604
  var valid_580605 = query.getOrDefault("oauth_token")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "oauth_token", valid_580605
  var valid_580606 = query.getOrDefault("generation")
  valid_580606 = validateParameter(valid_580606, JString, required = false,
                                 default = nil)
  if valid_580606 != nil:
    section.add "generation", valid_580606
  var valid_580607 = query.getOrDefault("userProject")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = nil)
  if valid_580607 != nil:
    section.add "userProject", valid_580607
  var valid_580608 = query.getOrDefault("alt")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = newJString("json"))
  if valid_580608 != nil:
    section.add "alt", valid_580608
  var valid_580609 = query.getOrDefault("userIp")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = nil)
  if valid_580609 != nil:
    section.add "userIp", valid_580609
  var valid_580610 = query.getOrDefault("quotaUser")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = nil)
  if valid_580610 != nil:
    section.add "quotaUser", valid_580610
  var valid_580611 = query.getOrDefault("provisionalUserProject")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "provisionalUserProject", valid_580611
  var valid_580612 = query.getOrDefault("fields")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = nil)
  if valid_580612 != nil:
    section.add "fields", valid_580612
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580613: Call_StorageObjectAccessControlsList_580598;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified object.
  ## 
  let valid = call_580613.validator(path, query, header, formData, body)
  let scheme = call_580613.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580613.url(scheme.get, call_580613.host, call_580613.base,
                         call_580613.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580613, url, valid)

proc call*(call_580614: Call_StorageObjectAccessControlsList_580598;
          bucket: string; `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageObjectAccessControlsList
  ## Retrieves ACL entries on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580615 = newJObject()
  var query_580616 = newJObject()
  add(query_580616, "key", newJString(key))
  add(query_580616, "prettyPrint", newJBool(prettyPrint))
  add(query_580616, "oauth_token", newJString(oauthToken))
  add(query_580616, "generation", newJString(generation))
  add(query_580616, "userProject", newJString(userProject))
  add(query_580616, "alt", newJString(alt))
  add(query_580616, "userIp", newJString(userIp))
  add(query_580616, "quotaUser", newJString(quotaUser))
  add(path_580615, "bucket", newJString(bucket))
  add(query_580616, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580615, "object", newJString(`object`))
  add(query_580616, "fields", newJString(fields))
  result = call_580614.call(path_580615, query_580616, nil, nil, nil)

var storageObjectAccessControlsList* = Call_StorageObjectAccessControlsList_580598(
    name: "storageObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsList_580599,
    base: "/storage/v1", url: url_StorageObjectAccessControlsList_580600,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsUpdate_580658 = ref object of OpenApiRestCall_579380
proc url_StorageObjectAccessControlsUpdate_580660(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsUpdate_580659(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an ACL entry on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580661 = path.getOrDefault("bucket")
  valid_580661 = validateParameter(valid_580661, JString, required = true,
                                 default = nil)
  if valid_580661 != nil:
    section.add "bucket", valid_580661
  var valid_580662 = path.getOrDefault("entity")
  valid_580662 = validateParameter(valid_580662, JString, required = true,
                                 default = nil)
  if valid_580662 != nil:
    section.add "entity", valid_580662
  var valid_580663 = path.getOrDefault("object")
  valid_580663 = validateParameter(valid_580663, JString, required = true,
                                 default = nil)
  if valid_580663 != nil:
    section.add "object", valid_580663
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580664 = query.getOrDefault("key")
  valid_580664 = validateParameter(valid_580664, JString, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "key", valid_580664
  var valid_580665 = query.getOrDefault("prettyPrint")
  valid_580665 = validateParameter(valid_580665, JBool, required = false,
                                 default = newJBool(true))
  if valid_580665 != nil:
    section.add "prettyPrint", valid_580665
  var valid_580666 = query.getOrDefault("oauth_token")
  valid_580666 = validateParameter(valid_580666, JString, required = false,
                                 default = nil)
  if valid_580666 != nil:
    section.add "oauth_token", valid_580666
  var valid_580667 = query.getOrDefault("generation")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = nil)
  if valid_580667 != nil:
    section.add "generation", valid_580667
  var valid_580668 = query.getOrDefault("userProject")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = nil)
  if valid_580668 != nil:
    section.add "userProject", valid_580668
  var valid_580669 = query.getOrDefault("alt")
  valid_580669 = validateParameter(valid_580669, JString, required = false,
                                 default = newJString("json"))
  if valid_580669 != nil:
    section.add "alt", valid_580669
  var valid_580670 = query.getOrDefault("userIp")
  valid_580670 = validateParameter(valid_580670, JString, required = false,
                                 default = nil)
  if valid_580670 != nil:
    section.add "userIp", valid_580670
  var valid_580671 = query.getOrDefault("quotaUser")
  valid_580671 = validateParameter(valid_580671, JString, required = false,
                                 default = nil)
  if valid_580671 != nil:
    section.add "quotaUser", valid_580671
  var valid_580672 = query.getOrDefault("provisionalUserProject")
  valid_580672 = validateParameter(valid_580672, JString, required = false,
                                 default = nil)
  if valid_580672 != nil:
    section.add "provisionalUserProject", valid_580672
  var valid_580673 = query.getOrDefault("fields")
  valid_580673 = validateParameter(valid_580673, JString, required = false,
                                 default = nil)
  if valid_580673 != nil:
    section.add "fields", valid_580673
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

proc call*(call_580675: Call_StorageObjectAccessControlsUpdate_580658;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified object.
  ## 
  let valid = call_580675.validator(path, query, header, formData, body)
  let scheme = call_580675.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580675.url(scheme.get, call_580675.host, call_580675.base,
                         call_580675.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580675, url, valid)

proc call*(call_580676: Call_StorageObjectAccessControlsUpdate_580658;
          bucket: string; entity: string; `object`: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; generation: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageObjectAccessControlsUpdate
  ## Updates an ACL entry on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580677 = newJObject()
  var query_580678 = newJObject()
  var body_580679 = newJObject()
  add(query_580678, "key", newJString(key))
  add(query_580678, "prettyPrint", newJBool(prettyPrint))
  add(query_580678, "oauth_token", newJString(oauthToken))
  add(query_580678, "generation", newJString(generation))
  add(query_580678, "userProject", newJString(userProject))
  add(query_580678, "alt", newJString(alt))
  add(query_580678, "userIp", newJString(userIp))
  add(query_580678, "quotaUser", newJString(quotaUser))
  add(path_580677, "bucket", newJString(bucket))
  if body != nil:
    body_580679 = body
  add(query_580678, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580677, "entity", newJString(entity))
  add(path_580677, "object", newJString(`object`))
  add(query_580678, "fields", newJString(fields))
  result = call_580676.call(path_580677, query_580678, nil, nil, body_580679)

var storageObjectAccessControlsUpdate* = Call_StorageObjectAccessControlsUpdate_580658(
    name: "storageObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsUpdate_580659,
    base: "/storage/v1", url: url_StorageObjectAccessControlsUpdate_580660,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsGet_580638 = ref object of OpenApiRestCall_579380
proc url_StorageObjectAccessControlsGet_580640(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsGet_580639(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the ACL entry for the specified entity on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580641 = path.getOrDefault("bucket")
  valid_580641 = validateParameter(valid_580641, JString, required = true,
                                 default = nil)
  if valid_580641 != nil:
    section.add "bucket", valid_580641
  var valid_580642 = path.getOrDefault("entity")
  valid_580642 = validateParameter(valid_580642, JString, required = true,
                                 default = nil)
  if valid_580642 != nil:
    section.add "entity", valid_580642
  var valid_580643 = path.getOrDefault("object")
  valid_580643 = validateParameter(valid_580643, JString, required = true,
                                 default = nil)
  if valid_580643 != nil:
    section.add "object", valid_580643
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580644 = query.getOrDefault("key")
  valid_580644 = validateParameter(valid_580644, JString, required = false,
                                 default = nil)
  if valid_580644 != nil:
    section.add "key", valid_580644
  var valid_580645 = query.getOrDefault("prettyPrint")
  valid_580645 = validateParameter(valid_580645, JBool, required = false,
                                 default = newJBool(true))
  if valid_580645 != nil:
    section.add "prettyPrint", valid_580645
  var valid_580646 = query.getOrDefault("oauth_token")
  valid_580646 = validateParameter(valid_580646, JString, required = false,
                                 default = nil)
  if valid_580646 != nil:
    section.add "oauth_token", valid_580646
  var valid_580647 = query.getOrDefault("generation")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = nil)
  if valid_580647 != nil:
    section.add "generation", valid_580647
  var valid_580648 = query.getOrDefault("userProject")
  valid_580648 = validateParameter(valid_580648, JString, required = false,
                                 default = nil)
  if valid_580648 != nil:
    section.add "userProject", valid_580648
  var valid_580649 = query.getOrDefault("alt")
  valid_580649 = validateParameter(valid_580649, JString, required = false,
                                 default = newJString("json"))
  if valid_580649 != nil:
    section.add "alt", valid_580649
  var valid_580650 = query.getOrDefault("userIp")
  valid_580650 = validateParameter(valid_580650, JString, required = false,
                                 default = nil)
  if valid_580650 != nil:
    section.add "userIp", valid_580650
  var valid_580651 = query.getOrDefault("quotaUser")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = nil)
  if valid_580651 != nil:
    section.add "quotaUser", valid_580651
  var valid_580652 = query.getOrDefault("provisionalUserProject")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = nil)
  if valid_580652 != nil:
    section.add "provisionalUserProject", valid_580652
  var valid_580653 = query.getOrDefault("fields")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = nil)
  if valid_580653 != nil:
    section.add "fields", valid_580653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580654: Call_StorageObjectAccessControlsGet_580638; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_580654.validator(path, query, header, formData, body)
  let scheme = call_580654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580654.url(scheme.get, call_580654.host, call_580654.base,
                         call_580654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580654, url, valid)

proc call*(call_580655: Call_StorageObjectAccessControlsGet_580638; bucket: string;
          entity: string; `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageObjectAccessControlsGet
  ## Returns the ACL entry for the specified entity on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580656 = newJObject()
  var query_580657 = newJObject()
  add(query_580657, "key", newJString(key))
  add(query_580657, "prettyPrint", newJBool(prettyPrint))
  add(query_580657, "oauth_token", newJString(oauthToken))
  add(query_580657, "generation", newJString(generation))
  add(query_580657, "userProject", newJString(userProject))
  add(query_580657, "alt", newJString(alt))
  add(query_580657, "userIp", newJString(userIp))
  add(query_580657, "quotaUser", newJString(quotaUser))
  add(path_580656, "bucket", newJString(bucket))
  add(query_580657, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580656, "entity", newJString(entity))
  add(path_580656, "object", newJString(`object`))
  add(query_580657, "fields", newJString(fields))
  result = call_580655.call(path_580656, query_580657, nil, nil, nil)

var storageObjectAccessControlsGet* = Call_StorageObjectAccessControlsGet_580638(
    name: "storageObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsGet_580639,
    base: "/storage/v1", url: url_StorageObjectAccessControlsGet_580640,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsPatch_580700 = ref object of OpenApiRestCall_579380
proc url_StorageObjectAccessControlsPatch_580702(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsPatch_580701(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches an ACL entry on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580703 = path.getOrDefault("bucket")
  valid_580703 = validateParameter(valid_580703, JString, required = true,
                                 default = nil)
  if valid_580703 != nil:
    section.add "bucket", valid_580703
  var valid_580704 = path.getOrDefault("entity")
  valid_580704 = validateParameter(valid_580704, JString, required = true,
                                 default = nil)
  if valid_580704 != nil:
    section.add "entity", valid_580704
  var valid_580705 = path.getOrDefault("object")
  valid_580705 = validateParameter(valid_580705, JString, required = true,
                                 default = nil)
  if valid_580705 != nil:
    section.add "object", valid_580705
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580706 = query.getOrDefault("key")
  valid_580706 = validateParameter(valid_580706, JString, required = false,
                                 default = nil)
  if valid_580706 != nil:
    section.add "key", valid_580706
  var valid_580707 = query.getOrDefault("prettyPrint")
  valid_580707 = validateParameter(valid_580707, JBool, required = false,
                                 default = newJBool(true))
  if valid_580707 != nil:
    section.add "prettyPrint", valid_580707
  var valid_580708 = query.getOrDefault("oauth_token")
  valid_580708 = validateParameter(valid_580708, JString, required = false,
                                 default = nil)
  if valid_580708 != nil:
    section.add "oauth_token", valid_580708
  var valid_580709 = query.getOrDefault("generation")
  valid_580709 = validateParameter(valid_580709, JString, required = false,
                                 default = nil)
  if valid_580709 != nil:
    section.add "generation", valid_580709
  var valid_580710 = query.getOrDefault("userProject")
  valid_580710 = validateParameter(valid_580710, JString, required = false,
                                 default = nil)
  if valid_580710 != nil:
    section.add "userProject", valid_580710
  var valid_580711 = query.getOrDefault("alt")
  valid_580711 = validateParameter(valid_580711, JString, required = false,
                                 default = newJString("json"))
  if valid_580711 != nil:
    section.add "alt", valid_580711
  var valid_580712 = query.getOrDefault("userIp")
  valid_580712 = validateParameter(valid_580712, JString, required = false,
                                 default = nil)
  if valid_580712 != nil:
    section.add "userIp", valid_580712
  var valid_580713 = query.getOrDefault("quotaUser")
  valid_580713 = validateParameter(valid_580713, JString, required = false,
                                 default = nil)
  if valid_580713 != nil:
    section.add "quotaUser", valid_580713
  var valid_580714 = query.getOrDefault("provisionalUserProject")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = nil)
  if valid_580714 != nil:
    section.add "provisionalUserProject", valid_580714
  var valid_580715 = query.getOrDefault("fields")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = nil)
  if valid_580715 != nil:
    section.add "fields", valid_580715
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

proc call*(call_580717: Call_StorageObjectAccessControlsPatch_580700;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Patches an ACL entry on the specified object.
  ## 
  let valid = call_580717.validator(path, query, header, formData, body)
  let scheme = call_580717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580717.url(scheme.get, call_580717.host, call_580717.base,
                         call_580717.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580717, url, valid)

proc call*(call_580718: Call_StorageObjectAccessControlsPatch_580700;
          bucket: string; entity: string; `object`: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; generation: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageObjectAccessControlsPatch
  ## Patches an ACL entry on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580719 = newJObject()
  var query_580720 = newJObject()
  var body_580721 = newJObject()
  add(query_580720, "key", newJString(key))
  add(query_580720, "prettyPrint", newJBool(prettyPrint))
  add(query_580720, "oauth_token", newJString(oauthToken))
  add(query_580720, "generation", newJString(generation))
  add(query_580720, "userProject", newJString(userProject))
  add(query_580720, "alt", newJString(alt))
  add(query_580720, "userIp", newJString(userIp))
  add(query_580720, "quotaUser", newJString(quotaUser))
  add(path_580719, "bucket", newJString(bucket))
  if body != nil:
    body_580721 = body
  add(query_580720, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580719, "entity", newJString(entity))
  add(path_580719, "object", newJString(`object`))
  add(query_580720, "fields", newJString(fields))
  result = call_580718.call(path_580719, query_580720, nil, nil, body_580721)

var storageObjectAccessControlsPatch* = Call_StorageObjectAccessControlsPatch_580700(
    name: "storageObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsPatch_580701,
    base: "/storage/v1", url: url_StorageObjectAccessControlsPatch_580702,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsDelete_580680 = ref object of OpenApiRestCall_579380
proc url_StorageObjectAccessControlsDelete_580682(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsDelete_580681(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes the ACL entry for the specified entity on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580683 = path.getOrDefault("bucket")
  valid_580683 = validateParameter(valid_580683, JString, required = true,
                                 default = nil)
  if valid_580683 != nil:
    section.add "bucket", valid_580683
  var valid_580684 = path.getOrDefault("entity")
  valid_580684 = validateParameter(valid_580684, JString, required = true,
                                 default = nil)
  if valid_580684 != nil:
    section.add "entity", valid_580684
  var valid_580685 = path.getOrDefault("object")
  valid_580685 = validateParameter(valid_580685, JString, required = true,
                                 default = nil)
  if valid_580685 != nil:
    section.add "object", valid_580685
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580686 = query.getOrDefault("key")
  valid_580686 = validateParameter(valid_580686, JString, required = false,
                                 default = nil)
  if valid_580686 != nil:
    section.add "key", valid_580686
  var valid_580687 = query.getOrDefault("prettyPrint")
  valid_580687 = validateParameter(valid_580687, JBool, required = false,
                                 default = newJBool(true))
  if valid_580687 != nil:
    section.add "prettyPrint", valid_580687
  var valid_580688 = query.getOrDefault("oauth_token")
  valid_580688 = validateParameter(valid_580688, JString, required = false,
                                 default = nil)
  if valid_580688 != nil:
    section.add "oauth_token", valid_580688
  var valid_580689 = query.getOrDefault("generation")
  valid_580689 = validateParameter(valid_580689, JString, required = false,
                                 default = nil)
  if valid_580689 != nil:
    section.add "generation", valid_580689
  var valid_580690 = query.getOrDefault("userProject")
  valid_580690 = validateParameter(valid_580690, JString, required = false,
                                 default = nil)
  if valid_580690 != nil:
    section.add "userProject", valid_580690
  var valid_580691 = query.getOrDefault("alt")
  valid_580691 = validateParameter(valid_580691, JString, required = false,
                                 default = newJString("json"))
  if valid_580691 != nil:
    section.add "alt", valid_580691
  var valid_580692 = query.getOrDefault("userIp")
  valid_580692 = validateParameter(valid_580692, JString, required = false,
                                 default = nil)
  if valid_580692 != nil:
    section.add "userIp", valid_580692
  var valid_580693 = query.getOrDefault("quotaUser")
  valid_580693 = validateParameter(valid_580693, JString, required = false,
                                 default = nil)
  if valid_580693 != nil:
    section.add "quotaUser", valid_580693
  var valid_580694 = query.getOrDefault("provisionalUserProject")
  valid_580694 = validateParameter(valid_580694, JString, required = false,
                                 default = nil)
  if valid_580694 != nil:
    section.add "provisionalUserProject", valid_580694
  var valid_580695 = query.getOrDefault("fields")
  valid_580695 = validateParameter(valid_580695, JString, required = false,
                                 default = nil)
  if valid_580695 != nil:
    section.add "fields", valid_580695
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580696: Call_StorageObjectAccessControlsDelete_580680;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_580696.validator(path, query, header, formData, body)
  let scheme = call_580696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580696.url(scheme.get, call_580696.host, call_580696.base,
                         call_580696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580696, url, valid)

proc call*(call_580697: Call_StorageObjectAccessControlsDelete_580680;
          bucket: string; entity: string; `object`: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; generation: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; provisionalUserProject: string = "";
          fields: string = ""): Recallable =
  ## storageObjectAccessControlsDelete
  ## Permanently deletes the ACL entry for the specified entity on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580698 = newJObject()
  var query_580699 = newJObject()
  add(query_580699, "key", newJString(key))
  add(query_580699, "prettyPrint", newJBool(prettyPrint))
  add(query_580699, "oauth_token", newJString(oauthToken))
  add(query_580699, "generation", newJString(generation))
  add(query_580699, "userProject", newJString(userProject))
  add(query_580699, "alt", newJString(alt))
  add(query_580699, "userIp", newJString(userIp))
  add(query_580699, "quotaUser", newJString(quotaUser))
  add(path_580698, "bucket", newJString(bucket))
  add(query_580699, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580698, "entity", newJString(entity))
  add(path_580698, "object", newJString(`object`))
  add(query_580699, "fields", newJString(fields))
  result = call_580697.call(path_580698, query_580699, nil, nil, nil)

var storageObjectAccessControlsDelete* = Call_StorageObjectAccessControlsDelete_580680(
    name: "storageObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsDelete_580681,
    base: "/storage/v1", url: url_StorageObjectAccessControlsDelete_580682,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsSetIamPolicy_580741 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsSetIamPolicy_580743(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/iam")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsSetIamPolicy_580742(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an IAM policy for the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580744 = path.getOrDefault("bucket")
  valid_580744 = validateParameter(valid_580744, JString, required = true,
                                 default = nil)
  if valid_580744 != nil:
    section.add "bucket", valid_580744
  var valid_580745 = path.getOrDefault("object")
  valid_580745 = validateParameter(valid_580745, JString, required = true,
                                 default = nil)
  if valid_580745 != nil:
    section.add "object", valid_580745
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580746 = query.getOrDefault("key")
  valid_580746 = validateParameter(valid_580746, JString, required = false,
                                 default = nil)
  if valid_580746 != nil:
    section.add "key", valid_580746
  var valid_580747 = query.getOrDefault("prettyPrint")
  valid_580747 = validateParameter(valid_580747, JBool, required = false,
                                 default = newJBool(true))
  if valid_580747 != nil:
    section.add "prettyPrint", valid_580747
  var valid_580748 = query.getOrDefault("oauth_token")
  valid_580748 = validateParameter(valid_580748, JString, required = false,
                                 default = nil)
  if valid_580748 != nil:
    section.add "oauth_token", valid_580748
  var valid_580749 = query.getOrDefault("generation")
  valid_580749 = validateParameter(valid_580749, JString, required = false,
                                 default = nil)
  if valid_580749 != nil:
    section.add "generation", valid_580749
  var valid_580750 = query.getOrDefault("userProject")
  valid_580750 = validateParameter(valid_580750, JString, required = false,
                                 default = nil)
  if valid_580750 != nil:
    section.add "userProject", valid_580750
  var valid_580751 = query.getOrDefault("alt")
  valid_580751 = validateParameter(valid_580751, JString, required = false,
                                 default = newJString("json"))
  if valid_580751 != nil:
    section.add "alt", valid_580751
  var valid_580752 = query.getOrDefault("userIp")
  valid_580752 = validateParameter(valid_580752, JString, required = false,
                                 default = nil)
  if valid_580752 != nil:
    section.add "userIp", valid_580752
  var valid_580753 = query.getOrDefault("quotaUser")
  valid_580753 = validateParameter(valid_580753, JString, required = false,
                                 default = nil)
  if valid_580753 != nil:
    section.add "quotaUser", valid_580753
  var valid_580754 = query.getOrDefault("provisionalUserProject")
  valid_580754 = validateParameter(valid_580754, JString, required = false,
                                 default = nil)
  if valid_580754 != nil:
    section.add "provisionalUserProject", valid_580754
  var valid_580755 = query.getOrDefault("fields")
  valid_580755 = validateParameter(valid_580755, JString, required = false,
                                 default = nil)
  if valid_580755 != nil:
    section.add "fields", valid_580755
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

proc call*(call_580757: Call_StorageObjectsSetIamPolicy_580741; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an IAM policy for the specified object.
  ## 
  let valid = call_580757.validator(path, query, header, formData, body)
  let scheme = call_580757.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580757.url(scheme.get, call_580757.host, call_580757.base,
                         call_580757.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580757, url, valid)

proc call*(call_580758: Call_StorageObjectsSetIamPolicy_580741; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageObjectsSetIamPolicy
  ## Updates an IAM policy for the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580759 = newJObject()
  var query_580760 = newJObject()
  var body_580761 = newJObject()
  add(query_580760, "key", newJString(key))
  add(query_580760, "prettyPrint", newJBool(prettyPrint))
  add(query_580760, "oauth_token", newJString(oauthToken))
  add(query_580760, "generation", newJString(generation))
  add(query_580760, "userProject", newJString(userProject))
  add(query_580760, "alt", newJString(alt))
  add(query_580760, "userIp", newJString(userIp))
  add(query_580760, "quotaUser", newJString(quotaUser))
  add(path_580759, "bucket", newJString(bucket))
  if body != nil:
    body_580761 = body
  add(query_580760, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580759, "object", newJString(`object`))
  add(query_580760, "fields", newJString(fields))
  result = call_580758.call(path_580759, query_580760, nil, nil, body_580761)

var storageObjectsSetIamPolicy* = Call_StorageObjectsSetIamPolicy_580741(
    name: "storageObjectsSetIamPolicy", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/iam",
    validator: validate_StorageObjectsSetIamPolicy_580742, base: "/storage/v1",
    url: url_StorageObjectsSetIamPolicy_580743, schemes: {Scheme.Https})
type
  Call_StorageObjectsGetIamPolicy_580722 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsGetIamPolicy_580724(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/iam")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsGetIamPolicy_580723(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns an IAM policy for the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580725 = path.getOrDefault("bucket")
  valid_580725 = validateParameter(valid_580725, JString, required = true,
                                 default = nil)
  if valid_580725 != nil:
    section.add "bucket", valid_580725
  var valid_580726 = path.getOrDefault("object")
  valid_580726 = validateParameter(valid_580726, JString, required = true,
                                 default = nil)
  if valid_580726 != nil:
    section.add "object", valid_580726
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580727 = query.getOrDefault("key")
  valid_580727 = validateParameter(valid_580727, JString, required = false,
                                 default = nil)
  if valid_580727 != nil:
    section.add "key", valid_580727
  var valid_580728 = query.getOrDefault("prettyPrint")
  valid_580728 = validateParameter(valid_580728, JBool, required = false,
                                 default = newJBool(true))
  if valid_580728 != nil:
    section.add "prettyPrint", valid_580728
  var valid_580729 = query.getOrDefault("oauth_token")
  valid_580729 = validateParameter(valid_580729, JString, required = false,
                                 default = nil)
  if valid_580729 != nil:
    section.add "oauth_token", valid_580729
  var valid_580730 = query.getOrDefault("generation")
  valid_580730 = validateParameter(valid_580730, JString, required = false,
                                 default = nil)
  if valid_580730 != nil:
    section.add "generation", valid_580730
  var valid_580731 = query.getOrDefault("userProject")
  valid_580731 = validateParameter(valid_580731, JString, required = false,
                                 default = nil)
  if valid_580731 != nil:
    section.add "userProject", valid_580731
  var valid_580732 = query.getOrDefault("alt")
  valid_580732 = validateParameter(valid_580732, JString, required = false,
                                 default = newJString("json"))
  if valid_580732 != nil:
    section.add "alt", valid_580732
  var valid_580733 = query.getOrDefault("userIp")
  valid_580733 = validateParameter(valid_580733, JString, required = false,
                                 default = nil)
  if valid_580733 != nil:
    section.add "userIp", valid_580733
  var valid_580734 = query.getOrDefault("quotaUser")
  valid_580734 = validateParameter(valid_580734, JString, required = false,
                                 default = nil)
  if valid_580734 != nil:
    section.add "quotaUser", valid_580734
  var valid_580735 = query.getOrDefault("provisionalUserProject")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = nil)
  if valid_580735 != nil:
    section.add "provisionalUserProject", valid_580735
  var valid_580736 = query.getOrDefault("fields")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = nil)
  if valid_580736 != nil:
    section.add "fields", valid_580736
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580737: Call_StorageObjectsGetIamPolicy_580722; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an IAM policy for the specified object.
  ## 
  let valid = call_580737.validator(path, query, header, formData, body)
  let scheme = call_580737.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580737.url(scheme.get, call_580737.host, call_580737.base,
                         call_580737.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580737, url, valid)

proc call*(call_580738: Call_StorageObjectsGetIamPolicy_580722; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageObjectsGetIamPolicy
  ## Returns an IAM policy for the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580739 = newJObject()
  var query_580740 = newJObject()
  add(query_580740, "key", newJString(key))
  add(query_580740, "prettyPrint", newJBool(prettyPrint))
  add(query_580740, "oauth_token", newJString(oauthToken))
  add(query_580740, "generation", newJString(generation))
  add(query_580740, "userProject", newJString(userProject))
  add(query_580740, "alt", newJString(alt))
  add(query_580740, "userIp", newJString(userIp))
  add(query_580740, "quotaUser", newJString(quotaUser))
  add(path_580739, "bucket", newJString(bucket))
  add(query_580740, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580739, "object", newJString(`object`))
  add(query_580740, "fields", newJString(fields))
  result = call_580738.call(path_580739, query_580740, nil, nil, nil)

var storageObjectsGetIamPolicy* = Call_StorageObjectsGetIamPolicy_580722(
    name: "storageObjectsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/iam",
    validator: validate_StorageObjectsGetIamPolicy_580723, base: "/storage/v1",
    url: url_StorageObjectsGetIamPolicy_580724, schemes: {Scheme.Https})
type
  Call_StorageObjectsTestIamPermissions_580762 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsTestIamPermissions_580764(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/iam/testPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsTestIamPermissions_580763(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Tests a set of permissions on the given object to see which, if any, are held by the caller.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580765 = path.getOrDefault("bucket")
  valid_580765 = validateParameter(valid_580765, JString, required = true,
                                 default = nil)
  if valid_580765 != nil:
    section.add "bucket", valid_580765
  var valid_580766 = path.getOrDefault("object")
  valid_580766 = validateParameter(valid_580766, JString, required = true,
                                 default = nil)
  if valid_580766 != nil:
    section.add "object", valid_580766
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   permissions: JArray (required)
  ##              : Permissions to test.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580767 = query.getOrDefault("key")
  valid_580767 = validateParameter(valid_580767, JString, required = false,
                                 default = nil)
  if valid_580767 != nil:
    section.add "key", valid_580767
  var valid_580768 = query.getOrDefault("prettyPrint")
  valid_580768 = validateParameter(valid_580768, JBool, required = false,
                                 default = newJBool(true))
  if valid_580768 != nil:
    section.add "prettyPrint", valid_580768
  var valid_580769 = query.getOrDefault("oauth_token")
  valid_580769 = validateParameter(valid_580769, JString, required = false,
                                 default = nil)
  if valid_580769 != nil:
    section.add "oauth_token", valid_580769
  var valid_580770 = query.getOrDefault("generation")
  valid_580770 = validateParameter(valid_580770, JString, required = false,
                                 default = nil)
  if valid_580770 != nil:
    section.add "generation", valid_580770
  var valid_580771 = query.getOrDefault("userProject")
  valid_580771 = validateParameter(valid_580771, JString, required = false,
                                 default = nil)
  if valid_580771 != nil:
    section.add "userProject", valid_580771
  assert query != nil,
        "query argument is necessary due to required `permissions` field"
  var valid_580772 = query.getOrDefault("permissions")
  valid_580772 = validateParameter(valid_580772, JArray, required = true, default = nil)
  if valid_580772 != nil:
    section.add "permissions", valid_580772
  var valid_580773 = query.getOrDefault("alt")
  valid_580773 = validateParameter(valid_580773, JString, required = false,
                                 default = newJString("json"))
  if valid_580773 != nil:
    section.add "alt", valid_580773
  var valid_580774 = query.getOrDefault("userIp")
  valid_580774 = validateParameter(valid_580774, JString, required = false,
                                 default = nil)
  if valid_580774 != nil:
    section.add "userIp", valid_580774
  var valid_580775 = query.getOrDefault("quotaUser")
  valid_580775 = validateParameter(valid_580775, JString, required = false,
                                 default = nil)
  if valid_580775 != nil:
    section.add "quotaUser", valid_580775
  var valid_580776 = query.getOrDefault("provisionalUserProject")
  valid_580776 = validateParameter(valid_580776, JString, required = false,
                                 default = nil)
  if valid_580776 != nil:
    section.add "provisionalUserProject", valid_580776
  var valid_580777 = query.getOrDefault("fields")
  valid_580777 = validateParameter(valid_580777, JString, required = false,
                                 default = nil)
  if valid_580777 != nil:
    section.add "fields", valid_580777
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580778: Call_StorageObjectsTestIamPermissions_580762;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests a set of permissions on the given object to see which, if any, are held by the caller.
  ## 
  let valid = call_580778.validator(path, query, header, formData, body)
  let scheme = call_580778.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580778.url(scheme.get, call_580778.host, call_580778.base,
                         call_580778.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580778, url, valid)

proc call*(call_580779: Call_StorageObjectsTestIamPermissions_580762;
          permissions: JsonNode; bucket: string; `object`: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; generation: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; provisionalUserProject: string = "";
          fields: string = ""): Recallable =
  ## storageObjectsTestIamPermissions
  ## Tests a set of permissions on the given object to see which, if any, are held by the caller.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   permissions: JArray (required)
  ##              : Permissions to test.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580780 = newJObject()
  var query_580781 = newJObject()
  add(query_580781, "key", newJString(key))
  add(query_580781, "prettyPrint", newJBool(prettyPrint))
  add(query_580781, "oauth_token", newJString(oauthToken))
  add(query_580781, "generation", newJString(generation))
  add(query_580781, "userProject", newJString(userProject))
  if permissions != nil:
    query_580781.add "permissions", permissions
  add(query_580781, "alt", newJString(alt))
  add(query_580781, "userIp", newJString(userIp))
  add(query_580781, "quotaUser", newJString(quotaUser))
  add(path_580780, "bucket", newJString(bucket))
  add(query_580781, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_580780, "object", newJString(`object`))
  add(query_580781, "fields", newJString(fields))
  result = call_580779.call(path_580780, query_580781, nil, nil, nil)

var storageObjectsTestIamPermissions* = Call_StorageObjectsTestIamPermissions_580762(
    name: "storageObjectsTestIamPermissions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/b/{bucket}/o/{object}/iam/testPermissions",
    validator: validate_StorageObjectsTestIamPermissions_580763,
    base: "/storage/v1", url: url_StorageObjectsTestIamPermissions_580764,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsCompose_580782 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsCompose_580784(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "destinationBucket" in path,
        "`destinationBucket` is a required path parameter"
  assert "destinationObject" in path,
        "`destinationObject` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "destinationBucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "destinationObject"),
               (kind: ConstantSegment, value: "/compose")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsCompose_580783(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   destinationObject: JString (required)
  ##                    : Name of the new object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   destinationBucket: JString (required)
  ##                    : Name of the bucket containing the source objects. The destination object is stored in this bucket.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `destinationObject` field"
  var valid_580785 = path.getOrDefault("destinationObject")
  valid_580785 = validateParameter(valid_580785, JString, required = true,
                                 default = nil)
  if valid_580785 != nil:
    section.add "destinationObject", valid_580785
  var valid_580786 = path.getOrDefault("destinationBucket")
  valid_580786 = validateParameter(valid_580786, JString, required = true,
                                 default = nil)
  if valid_580786 != nil:
    section.add "destinationBucket", valid_580786
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   kmsKeyName: JString
  ##             : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  ##   destinationPredefinedAcl: JString
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580787 = query.getOrDefault("key")
  valid_580787 = validateParameter(valid_580787, JString, required = false,
                                 default = nil)
  if valid_580787 != nil:
    section.add "key", valid_580787
  var valid_580788 = query.getOrDefault("prettyPrint")
  valid_580788 = validateParameter(valid_580788, JBool, required = false,
                                 default = newJBool(true))
  if valid_580788 != nil:
    section.add "prettyPrint", valid_580788
  var valid_580789 = query.getOrDefault("oauth_token")
  valid_580789 = validateParameter(valid_580789, JString, required = false,
                                 default = nil)
  if valid_580789 != nil:
    section.add "oauth_token", valid_580789
  var valid_580790 = query.getOrDefault("kmsKeyName")
  valid_580790 = validateParameter(valid_580790, JString, required = false,
                                 default = nil)
  if valid_580790 != nil:
    section.add "kmsKeyName", valid_580790
  var valid_580791 = query.getOrDefault("destinationPredefinedAcl")
  valid_580791 = validateParameter(valid_580791, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_580791 != nil:
    section.add "destinationPredefinedAcl", valid_580791
  var valid_580792 = query.getOrDefault("userProject")
  valid_580792 = validateParameter(valid_580792, JString, required = false,
                                 default = nil)
  if valid_580792 != nil:
    section.add "userProject", valid_580792
  var valid_580793 = query.getOrDefault("ifGenerationMatch")
  valid_580793 = validateParameter(valid_580793, JString, required = false,
                                 default = nil)
  if valid_580793 != nil:
    section.add "ifGenerationMatch", valid_580793
  var valid_580794 = query.getOrDefault("alt")
  valid_580794 = validateParameter(valid_580794, JString, required = false,
                                 default = newJString("json"))
  if valid_580794 != nil:
    section.add "alt", valid_580794
  var valid_580795 = query.getOrDefault("userIp")
  valid_580795 = validateParameter(valid_580795, JString, required = false,
                                 default = nil)
  if valid_580795 != nil:
    section.add "userIp", valid_580795
  var valid_580796 = query.getOrDefault("quotaUser")
  valid_580796 = validateParameter(valid_580796, JString, required = false,
                                 default = nil)
  if valid_580796 != nil:
    section.add "quotaUser", valid_580796
  var valid_580797 = query.getOrDefault("ifMetagenerationMatch")
  valid_580797 = validateParameter(valid_580797, JString, required = false,
                                 default = nil)
  if valid_580797 != nil:
    section.add "ifMetagenerationMatch", valid_580797
  var valid_580798 = query.getOrDefault("provisionalUserProject")
  valid_580798 = validateParameter(valid_580798, JString, required = false,
                                 default = nil)
  if valid_580798 != nil:
    section.add "provisionalUserProject", valid_580798
  var valid_580799 = query.getOrDefault("fields")
  valid_580799 = validateParameter(valid_580799, JString, required = false,
                                 default = nil)
  if valid_580799 != nil:
    section.add "fields", valid_580799
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

proc call*(call_580801: Call_StorageObjectsCompose_580782; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ## 
  let valid = call_580801.validator(path, query, header, formData, body)
  let scheme = call_580801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580801.url(scheme.get, call_580801.host, call_580801.base,
                         call_580801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580801, url, valid)

proc call*(call_580802: Call_StorageObjectsCompose_580782;
          destinationObject: string; destinationBucket: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; kmsKeyName: string = "";
          destinationPredefinedAcl: string = "authenticatedRead";
          userProject: string = ""; ifGenerationMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageObjectsCompose
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   kmsKeyName: string
  ##             : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  ##   destinationObject: string (required)
  ##                    : Name of the new object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   destinationPredefinedAcl: string
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   destinationBucket: string (required)
  ##                    : Name of the bucket containing the source objects. The destination object is stored in this bucket.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580803 = newJObject()
  var query_580804 = newJObject()
  var body_580805 = newJObject()
  add(query_580804, "key", newJString(key))
  add(query_580804, "prettyPrint", newJBool(prettyPrint))
  add(query_580804, "oauth_token", newJString(oauthToken))
  add(query_580804, "kmsKeyName", newJString(kmsKeyName))
  add(path_580803, "destinationObject", newJString(destinationObject))
  add(query_580804, "destinationPredefinedAcl",
      newJString(destinationPredefinedAcl))
  add(query_580804, "userProject", newJString(userProject))
  add(path_580803, "destinationBucket", newJString(destinationBucket))
  add(query_580804, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580804, "alt", newJString(alt))
  add(query_580804, "userIp", newJString(userIp))
  add(query_580804, "quotaUser", newJString(quotaUser))
  add(query_580804, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_580805 = body
  add(query_580804, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580804, "fields", newJString(fields))
  result = call_580802.call(path_580803, query_580804, nil, nil, body_580805)

var storageObjectsCompose* = Call_StorageObjectsCompose_580782(
    name: "storageObjectsCompose", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/b/{destinationBucket}/o/{destinationObject}/compose",
    validator: validate_StorageObjectsCompose_580783, base: "/storage/v1",
    url: url_StorageObjectsCompose_580784, schemes: {Scheme.Https})
type
  Call_StorageObjectsCopy_580806 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsCopy_580808(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "sourceBucket" in path, "`sourceBucket` is a required path parameter"
  assert "sourceObject" in path, "`sourceObject` is a required path parameter"
  assert "destinationBucket" in path,
        "`destinationBucket` is a required path parameter"
  assert "destinationObject" in path,
        "`destinationObject` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "sourceBucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "sourceObject"),
               (kind: ConstantSegment, value: "/copyTo/b/"),
               (kind: VariableSegment, value: "destinationBucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "destinationObject")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsCopy_580807(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Copies a source object to a destination object. Optionally overrides metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   destinationObject: JString (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   destinationBucket: JString (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   sourceObject: JString (required)
  ##               : Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   sourceBucket: JString (required)
  ##               : Name of the bucket in which to find the source object.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `destinationObject` field"
  var valid_580809 = path.getOrDefault("destinationObject")
  valid_580809 = validateParameter(valid_580809, JString, required = true,
                                 default = nil)
  if valid_580809 != nil:
    section.add "destinationObject", valid_580809
  var valid_580810 = path.getOrDefault("destinationBucket")
  valid_580810 = validateParameter(valid_580810, JString, required = true,
                                 default = nil)
  if valid_580810 != nil:
    section.add "destinationBucket", valid_580810
  var valid_580811 = path.getOrDefault("sourceObject")
  valid_580811 = validateParameter(valid_580811, JString, required = true,
                                 default = nil)
  if valid_580811 != nil:
    section.add "sourceObject", valid_580811
  var valid_580812 = path.getOrDefault("sourceBucket")
  valid_580812 = validateParameter(valid_580812, JString, required = true,
                                 default = nil)
  if valid_580812 != nil:
    section.add "sourceBucket", valid_580812
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifSourceGenerationMatch: JString
  ##                          : Makes the operation conditional on whether the source object's current generation matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   destinationPredefinedAcl: JString
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   ifSourceMetagenerationNotMatch: JString
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the destination object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the destination object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifSourceGenerationNotMatch: JString
  ##                             : Makes the operation conditional on whether the source object's current generation does not match the given value.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   sourceGeneration: JString
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   ifSourceMetagenerationMatch: JString
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580813 = query.getOrDefault("key")
  valid_580813 = validateParameter(valid_580813, JString, required = false,
                                 default = nil)
  if valid_580813 != nil:
    section.add "key", valid_580813
  var valid_580814 = query.getOrDefault("ifSourceGenerationMatch")
  valid_580814 = validateParameter(valid_580814, JString, required = false,
                                 default = nil)
  if valid_580814 != nil:
    section.add "ifSourceGenerationMatch", valid_580814
  var valid_580815 = query.getOrDefault("prettyPrint")
  valid_580815 = validateParameter(valid_580815, JBool, required = false,
                                 default = newJBool(true))
  if valid_580815 != nil:
    section.add "prettyPrint", valid_580815
  var valid_580816 = query.getOrDefault("oauth_token")
  valid_580816 = validateParameter(valid_580816, JString, required = false,
                                 default = nil)
  if valid_580816 != nil:
    section.add "oauth_token", valid_580816
  var valid_580817 = query.getOrDefault("destinationPredefinedAcl")
  valid_580817 = validateParameter(valid_580817, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_580817 != nil:
    section.add "destinationPredefinedAcl", valid_580817
  var valid_580818 = query.getOrDefault("userProject")
  valid_580818 = validateParameter(valid_580818, JString, required = false,
                                 default = nil)
  if valid_580818 != nil:
    section.add "userProject", valid_580818
  var valid_580819 = query.getOrDefault("ifSourceMetagenerationNotMatch")
  valid_580819 = validateParameter(valid_580819, JString, required = false,
                                 default = nil)
  if valid_580819 != nil:
    section.add "ifSourceMetagenerationNotMatch", valid_580819
  var valid_580820 = query.getOrDefault("ifGenerationMatch")
  valid_580820 = validateParameter(valid_580820, JString, required = false,
                                 default = nil)
  if valid_580820 != nil:
    section.add "ifGenerationMatch", valid_580820
  var valid_580821 = query.getOrDefault("alt")
  valid_580821 = validateParameter(valid_580821, JString, required = false,
                                 default = newJString("json"))
  if valid_580821 != nil:
    section.add "alt", valid_580821
  var valid_580822 = query.getOrDefault("userIp")
  valid_580822 = validateParameter(valid_580822, JString, required = false,
                                 default = nil)
  if valid_580822 != nil:
    section.add "userIp", valid_580822
  var valid_580823 = query.getOrDefault("ifGenerationNotMatch")
  valid_580823 = validateParameter(valid_580823, JString, required = false,
                                 default = nil)
  if valid_580823 != nil:
    section.add "ifGenerationNotMatch", valid_580823
  var valid_580824 = query.getOrDefault("quotaUser")
  valid_580824 = validateParameter(valid_580824, JString, required = false,
                                 default = nil)
  if valid_580824 != nil:
    section.add "quotaUser", valid_580824
  var valid_580825 = query.getOrDefault("ifSourceGenerationNotMatch")
  valid_580825 = validateParameter(valid_580825, JString, required = false,
                                 default = nil)
  if valid_580825 != nil:
    section.add "ifSourceGenerationNotMatch", valid_580825
  var valid_580826 = query.getOrDefault("ifMetagenerationMatch")
  valid_580826 = validateParameter(valid_580826, JString, required = false,
                                 default = nil)
  if valid_580826 != nil:
    section.add "ifMetagenerationMatch", valid_580826
  var valid_580827 = query.getOrDefault("sourceGeneration")
  valid_580827 = validateParameter(valid_580827, JString, required = false,
                                 default = nil)
  if valid_580827 != nil:
    section.add "sourceGeneration", valid_580827
  var valid_580828 = query.getOrDefault("ifSourceMetagenerationMatch")
  valid_580828 = validateParameter(valid_580828, JString, required = false,
                                 default = nil)
  if valid_580828 != nil:
    section.add "ifSourceMetagenerationMatch", valid_580828
  var valid_580829 = query.getOrDefault("provisionalUserProject")
  valid_580829 = validateParameter(valid_580829, JString, required = false,
                                 default = nil)
  if valid_580829 != nil:
    section.add "provisionalUserProject", valid_580829
  var valid_580830 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580830 = validateParameter(valid_580830, JString, required = false,
                                 default = nil)
  if valid_580830 != nil:
    section.add "ifMetagenerationNotMatch", valid_580830
  var valid_580831 = query.getOrDefault("projection")
  valid_580831 = validateParameter(valid_580831, JString, required = false,
                                 default = newJString("full"))
  if valid_580831 != nil:
    section.add "projection", valid_580831
  var valid_580832 = query.getOrDefault("fields")
  valid_580832 = validateParameter(valid_580832, JString, required = false,
                                 default = nil)
  if valid_580832 != nil:
    section.add "fields", valid_580832
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

proc call*(call_580834: Call_StorageObjectsCopy_580806; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies a source object to a destination object. Optionally overrides metadata.
  ## 
  let valid = call_580834.validator(path, query, header, formData, body)
  let scheme = call_580834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580834.url(scheme.get, call_580834.host, call_580834.base,
                         call_580834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580834, url, valid)

proc call*(call_580835: Call_StorageObjectsCopy_580806; destinationObject: string;
          destinationBucket: string; sourceObject: string; sourceBucket: string;
          key: string = ""; ifSourceGenerationMatch: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          destinationPredefinedAcl: string = "authenticatedRead";
          userProject: string = ""; ifSourceMetagenerationNotMatch: string = "";
          ifGenerationMatch: string = ""; alt: string = "json"; userIp: string = "";
          ifGenerationNotMatch: string = ""; quotaUser: string = "";
          ifSourceGenerationNotMatch: string = "";
          ifMetagenerationMatch: string = ""; sourceGeneration: string = "";
          ifSourceMetagenerationMatch: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageObjectsCopy
  ## Copies a source object to a destination object. Optionally overrides metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifSourceGenerationMatch: string
  ##                          : Makes the operation conditional on whether the source object's current generation matches the given value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   destinationObject: string (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   destinationPredefinedAcl: string
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   ifSourceMetagenerationNotMatch: string
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   destinationBucket: string (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the destination object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the destination object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifSourceGenerationNotMatch: string
  ##                             : Makes the operation conditional on whether the source object's current generation does not match the given value.
  ##   sourceObject: string (required)
  ##               : Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   sourceGeneration: string
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   ifSourceMetagenerationMatch: string
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   sourceBucket: string (required)
  ##               : Name of the bucket in which to find the source object.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580836 = newJObject()
  var query_580837 = newJObject()
  var body_580838 = newJObject()
  add(query_580837, "key", newJString(key))
  add(query_580837, "ifSourceGenerationMatch", newJString(ifSourceGenerationMatch))
  add(query_580837, "prettyPrint", newJBool(prettyPrint))
  add(query_580837, "oauth_token", newJString(oauthToken))
  add(path_580836, "destinationObject", newJString(destinationObject))
  add(query_580837, "destinationPredefinedAcl",
      newJString(destinationPredefinedAcl))
  add(query_580837, "userProject", newJString(userProject))
  add(query_580837, "ifSourceMetagenerationNotMatch",
      newJString(ifSourceMetagenerationNotMatch))
  add(path_580836, "destinationBucket", newJString(destinationBucket))
  add(query_580837, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580837, "alt", newJString(alt))
  add(query_580837, "userIp", newJString(userIp))
  add(query_580837, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580837, "quotaUser", newJString(quotaUser))
  add(query_580837, "ifSourceGenerationNotMatch",
      newJString(ifSourceGenerationNotMatch))
  add(path_580836, "sourceObject", newJString(sourceObject))
  add(query_580837, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580837, "sourceGeneration", newJString(sourceGeneration))
  add(query_580837, "ifSourceMetagenerationMatch",
      newJString(ifSourceMetagenerationMatch))
  add(path_580836, "sourceBucket", newJString(sourceBucket))
  if body != nil:
    body_580838 = body
  add(query_580837, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580837, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580837, "projection", newJString(projection))
  add(query_580837, "fields", newJString(fields))
  result = call_580835.call(path_580836, query_580837, nil, nil, body_580838)

var storageObjectsCopy* = Call_StorageObjectsCopy_580806(
    name: "storageObjectsCopy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{sourceBucket}/o/{sourceObject}/copyTo/b/{destinationBucket}/o/{destinationObject}",
    validator: validate_StorageObjectsCopy_580807, base: "/storage/v1",
    url: url_StorageObjectsCopy_580808, schemes: {Scheme.Https})
type
  Call_StorageObjectsRewrite_580839 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsRewrite_580841(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "sourceBucket" in path, "`sourceBucket` is a required path parameter"
  assert "sourceObject" in path, "`sourceObject` is a required path parameter"
  assert "destinationBucket" in path,
        "`destinationBucket` is a required path parameter"
  assert "destinationObject" in path,
        "`destinationObject` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "sourceBucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "sourceObject"),
               (kind: ConstantSegment, value: "/rewriteTo/b/"),
               (kind: VariableSegment, value: "destinationBucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "destinationObject")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsRewrite_580840(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rewrites a source object to a destination object. Optionally overrides metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   destinationObject: JString (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   destinationBucket: JString (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   sourceObject: JString (required)
  ##               : Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   sourceBucket: JString (required)
  ##               : Name of the bucket in which to find the source object.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `destinationObject` field"
  var valid_580842 = path.getOrDefault("destinationObject")
  valid_580842 = validateParameter(valid_580842, JString, required = true,
                                 default = nil)
  if valid_580842 != nil:
    section.add "destinationObject", valid_580842
  var valid_580843 = path.getOrDefault("destinationBucket")
  valid_580843 = validateParameter(valid_580843, JString, required = true,
                                 default = nil)
  if valid_580843 != nil:
    section.add "destinationBucket", valid_580843
  var valid_580844 = path.getOrDefault("sourceObject")
  valid_580844 = validateParameter(valid_580844, JString, required = true,
                                 default = nil)
  if valid_580844 != nil:
    section.add "sourceObject", valid_580844
  var valid_580845 = path.getOrDefault("sourceBucket")
  valid_580845 = validateParameter(valid_580845, JString, required = true,
                                 default = nil)
  if valid_580845 != nil:
    section.add "sourceBucket", valid_580845
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifSourceGenerationMatch: JString
  ##                          : Makes the operation conditional on whether the source object's current generation matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   destinationPredefinedAcl: JString
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   ifSourceMetagenerationNotMatch: JString
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifSourceGenerationNotMatch: JString
  ##                             : Makes the operation conditional on whether the source object's current generation does not match the given value.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   rewriteToken: JString
  ##               : Include this field (from the previous rewrite response) on each rewrite request after the first one, until the rewrite response 'done' flag is true. Calls that provide a rewriteToken can omit all other request fields, but if included those fields must match the values provided in the first rewrite request.
  ##   sourceGeneration: JString
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   ifSourceMetagenerationMatch: JString
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   maxBytesRewrittenPerCall: JString
  ##                           : The maximum number of bytes that will be rewritten per rewrite request. Most callers shouldn't need to specify this parameter - it is primarily in place to support testing. If specified the value must be an integral multiple of 1 MiB (1048576). Also, this only applies to requests where the source and destination span locations and/or storage classes. Finally, this value must not change across rewrite calls else you'll get an error that the rewriteToken is invalid.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   destinationKmsKeyName: JString
  ##                        : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  section = newJObject()
  var valid_580846 = query.getOrDefault("key")
  valid_580846 = validateParameter(valid_580846, JString, required = false,
                                 default = nil)
  if valid_580846 != nil:
    section.add "key", valid_580846
  var valid_580847 = query.getOrDefault("ifSourceGenerationMatch")
  valid_580847 = validateParameter(valid_580847, JString, required = false,
                                 default = nil)
  if valid_580847 != nil:
    section.add "ifSourceGenerationMatch", valid_580847
  var valid_580848 = query.getOrDefault("prettyPrint")
  valid_580848 = validateParameter(valid_580848, JBool, required = false,
                                 default = newJBool(true))
  if valid_580848 != nil:
    section.add "prettyPrint", valid_580848
  var valid_580849 = query.getOrDefault("oauth_token")
  valid_580849 = validateParameter(valid_580849, JString, required = false,
                                 default = nil)
  if valid_580849 != nil:
    section.add "oauth_token", valid_580849
  var valid_580850 = query.getOrDefault("destinationPredefinedAcl")
  valid_580850 = validateParameter(valid_580850, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_580850 != nil:
    section.add "destinationPredefinedAcl", valid_580850
  var valid_580851 = query.getOrDefault("userProject")
  valid_580851 = validateParameter(valid_580851, JString, required = false,
                                 default = nil)
  if valid_580851 != nil:
    section.add "userProject", valid_580851
  var valid_580852 = query.getOrDefault("ifSourceMetagenerationNotMatch")
  valid_580852 = validateParameter(valid_580852, JString, required = false,
                                 default = nil)
  if valid_580852 != nil:
    section.add "ifSourceMetagenerationNotMatch", valid_580852
  var valid_580853 = query.getOrDefault("ifGenerationMatch")
  valid_580853 = validateParameter(valid_580853, JString, required = false,
                                 default = nil)
  if valid_580853 != nil:
    section.add "ifGenerationMatch", valid_580853
  var valid_580854 = query.getOrDefault("alt")
  valid_580854 = validateParameter(valid_580854, JString, required = false,
                                 default = newJString("json"))
  if valid_580854 != nil:
    section.add "alt", valid_580854
  var valid_580855 = query.getOrDefault("userIp")
  valid_580855 = validateParameter(valid_580855, JString, required = false,
                                 default = nil)
  if valid_580855 != nil:
    section.add "userIp", valid_580855
  var valid_580856 = query.getOrDefault("ifGenerationNotMatch")
  valid_580856 = validateParameter(valid_580856, JString, required = false,
                                 default = nil)
  if valid_580856 != nil:
    section.add "ifGenerationNotMatch", valid_580856
  var valid_580857 = query.getOrDefault("quotaUser")
  valid_580857 = validateParameter(valid_580857, JString, required = false,
                                 default = nil)
  if valid_580857 != nil:
    section.add "quotaUser", valid_580857
  var valid_580858 = query.getOrDefault("ifSourceGenerationNotMatch")
  valid_580858 = validateParameter(valid_580858, JString, required = false,
                                 default = nil)
  if valid_580858 != nil:
    section.add "ifSourceGenerationNotMatch", valid_580858
  var valid_580859 = query.getOrDefault("ifMetagenerationMatch")
  valid_580859 = validateParameter(valid_580859, JString, required = false,
                                 default = nil)
  if valid_580859 != nil:
    section.add "ifMetagenerationMatch", valid_580859
  var valid_580860 = query.getOrDefault("rewriteToken")
  valid_580860 = validateParameter(valid_580860, JString, required = false,
                                 default = nil)
  if valid_580860 != nil:
    section.add "rewriteToken", valid_580860
  var valid_580861 = query.getOrDefault("sourceGeneration")
  valid_580861 = validateParameter(valid_580861, JString, required = false,
                                 default = nil)
  if valid_580861 != nil:
    section.add "sourceGeneration", valid_580861
  var valid_580862 = query.getOrDefault("ifSourceMetagenerationMatch")
  valid_580862 = validateParameter(valid_580862, JString, required = false,
                                 default = nil)
  if valid_580862 != nil:
    section.add "ifSourceMetagenerationMatch", valid_580862
  var valid_580863 = query.getOrDefault("maxBytesRewrittenPerCall")
  valid_580863 = validateParameter(valid_580863, JString, required = false,
                                 default = nil)
  if valid_580863 != nil:
    section.add "maxBytesRewrittenPerCall", valid_580863
  var valid_580864 = query.getOrDefault("provisionalUserProject")
  valid_580864 = validateParameter(valid_580864, JString, required = false,
                                 default = nil)
  if valid_580864 != nil:
    section.add "provisionalUserProject", valid_580864
  var valid_580865 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580865 = validateParameter(valid_580865, JString, required = false,
                                 default = nil)
  if valid_580865 != nil:
    section.add "ifMetagenerationNotMatch", valid_580865
  var valid_580866 = query.getOrDefault("projection")
  valid_580866 = validateParameter(valid_580866, JString, required = false,
                                 default = newJString("full"))
  if valid_580866 != nil:
    section.add "projection", valid_580866
  var valid_580867 = query.getOrDefault("fields")
  valid_580867 = validateParameter(valid_580867, JString, required = false,
                                 default = nil)
  if valid_580867 != nil:
    section.add "fields", valid_580867
  var valid_580868 = query.getOrDefault("destinationKmsKeyName")
  valid_580868 = validateParameter(valid_580868, JString, required = false,
                                 default = nil)
  if valid_580868 != nil:
    section.add "destinationKmsKeyName", valid_580868
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

proc call*(call_580870: Call_StorageObjectsRewrite_580839; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rewrites a source object to a destination object. Optionally overrides metadata.
  ## 
  let valid = call_580870.validator(path, query, header, formData, body)
  let scheme = call_580870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580870.url(scheme.get, call_580870.host, call_580870.base,
                         call_580870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580870, url, valid)

proc call*(call_580871: Call_StorageObjectsRewrite_580839;
          destinationObject: string; destinationBucket: string;
          sourceObject: string; sourceBucket: string; key: string = "";
          ifSourceGenerationMatch: string = ""; prettyPrint: bool = true;
          oauthToken: string = "";
          destinationPredefinedAcl: string = "authenticatedRead";
          userProject: string = ""; ifSourceMetagenerationNotMatch: string = "";
          ifGenerationMatch: string = ""; alt: string = "json"; userIp: string = "";
          ifGenerationNotMatch: string = ""; quotaUser: string = "";
          ifSourceGenerationNotMatch: string = "";
          ifMetagenerationMatch: string = ""; rewriteToken: string = "";
          sourceGeneration: string = ""; ifSourceMetagenerationMatch: string = "";
          body: JsonNode = nil; maxBytesRewrittenPerCall: string = "";
          provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""; destinationKmsKeyName: string = ""): Recallable =
  ## storageObjectsRewrite
  ## Rewrites a source object to a destination object. Optionally overrides metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifSourceGenerationMatch: string
  ##                          : Makes the operation conditional on whether the source object's current generation matches the given value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   destinationObject: string (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   destinationPredefinedAcl: string
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   ifSourceMetagenerationNotMatch: string
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   destinationBucket: string (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifSourceGenerationNotMatch: string
  ##                             : Makes the operation conditional on whether the source object's current generation does not match the given value.
  ##   sourceObject: string (required)
  ##               : Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   rewriteToken: string
  ##               : Include this field (from the previous rewrite response) on each rewrite request after the first one, until the rewrite response 'done' flag is true. Calls that provide a rewriteToken can omit all other request fields, but if included those fields must match the values provided in the first rewrite request.
  ##   sourceGeneration: string
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   ifSourceMetagenerationMatch: string
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   sourceBucket: string (required)
  ##               : Name of the bucket in which to find the source object.
  ##   body: JObject
  ##   maxBytesRewrittenPerCall: string
  ##                           : The maximum number of bytes that will be rewritten per rewrite request. Most callers shouldn't need to specify this parameter - it is primarily in place to support testing. If specified the value must be an integral multiple of 1 MiB (1048576). Also, this only applies to requests where the source and destination span locations and/or storage classes. Finally, this value must not change across rewrite calls else you'll get an error that the rewriteToken is invalid.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   destinationKmsKeyName: string
  ##                        : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  var path_580872 = newJObject()
  var query_580873 = newJObject()
  var body_580874 = newJObject()
  add(query_580873, "key", newJString(key))
  add(query_580873, "ifSourceGenerationMatch", newJString(ifSourceGenerationMatch))
  add(query_580873, "prettyPrint", newJBool(prettyPrint))
  add(query_580873, "oauth_token", newJString(oauthToken))
  add(path_580872, "destinationObject", newJString(destinationObject))
  add(query_580873, "destinationPredefinedAcl",
      newJString(destinationPredefinedAcl))
  add(query_580873, "userProject", newJString(userProject))
  add(query_580873, "ifSourceMetagenerationNotMatch",
      newJString(ifSourceMetagenerationNotMatch))
  add(path_580872, "destinationBucket", newJString(destinationBucket))
  add(query_580873, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580873, "alt", newJString(alt))
  add(query_580873, "userIp", newJString(userIp))
  add(query_580873, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580873, "quotaUser", newJString(quotaUser))
  add(query_580873, "ifSourceGenerationNotMatch",
      newJString(ifSourceGenerationNotMatch))
  add(path_580872, "sourceObject", newJString(sourceObject))
  add(query_580873, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580873, "rewriteToken", newJString(rewriteToken))
  add(query_580873, "sourceGeneration", newJString(sourceGeneration))
  add(query_580873, "ifSourceMetagenerationMatch",
      newJString(ifSourceMetagenerationMatch))
  add(path_580872, "sourceBucket", newJString(sourceBucket))
  if body != nil:
    body_580874 = body
  add(query_580873, "maxBytesRewrittenPerCall",
      newJString(maxBytesRewrittenPerCall))
  add(query_580873, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580873, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580873, "projection", newJString(projection))
  add(query_580873, "fields", newJString(fields))
  add(query_580873, "destinationKmsKeyName", newJString(destinationKmsKeyName))
  result = call_580871.call(path_580872, query_580873, nil, nil, body_580874)

var storageObjectsRewrite* = Call_StorageObjectsRewrite_580839(
    name: "storageObjectsRewrite", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{sourceBucket}/o/{sourceObject}/rewriteTo/b/{destinationBucket}/o/{destinationObject}",
    validator: validate_StorageObjectsRewrite_580840, base: "/storage/v1",
    url: url_StorageObjectsRewrite_580841, schemes: {Scheme.Https})
type
  Call_StorageChannelsStop_580875 = ref object of OpenApiRestCall_579380
proc url_StorageChannelsStop_580877(protocol: Scheme; host: string; base: string;
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

proc validate_StorageChannelsStop_580876(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Stop watching resources through this channel
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
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580878 = query.getOrDefault("key")
  valid_580878 = validateParameter(valid_580878, JString, required = false,
                                 default = nil)
  if valid_580878 != nil:
    section.add "key", valid_580878
  var valid_580879 = query.getOrDefault("prettyPrint")
  valid_580879 = validateParameter(valid_580879, JBool, required = false,
                                 default = newJBool(true))
  if valid_580879 != nil:
    section.add "prettyPrint", valid_580879
  var valid_580880 = query.getOrDefault("oauth_token")
  valid_580880 = validateParameter(valid_580880, JString, required = false,
                                 default = nil)
  if valid_580880 != nil:
    section.add "oauth_token", valid_580880
  var valid_580881 = query.getOrDefault("alt")
  valid_580881 = validateParameter(valid_580881, JString, required = false,
                                 default = newJString("json"))
  if valid_580881 != nil:
    section.add "alt", valid_580881
  var valid_580882 = query.getOrDefault("userIp")
  valid_580882 = validateParameter(valid_580882, JString, required = false,
                                 default = nil)
  if valid_580882 != nil:
    section.add "userIp", valid_580882
  var valid_580883 = query.getOrDefault("quotaUser")
  valid_580883 = validateParameter(valid_580883, JString, required = false,
                                 default = nil)
  if valid_580883 != nil:
    section.add "quotaUser", valid_580883
  var valid_580884 = query.getOrDefault("fields")
  valid_580884 = validateParameter(valid_580884, JString, required = false,
                                 default = nil)
  if valid_580884 != nil:
    section.add "fields", valid_580884
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resource: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580886: Call_StorageChannelsStop_580875; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_580886.validator(path, query, header, formData, body)
  let scheme = call_580886.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580886.url(scheme.get, call_580886.host, call_580886.base,
                         call_580886.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580886, url, valid)

proc call*(call_580887: Call_StorageChannelsStop_580875; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; resource: JsonNode = nil;
          fields: string = ""): Recallable =
  ## storageChannelsStop
  ## Stop watching resources through this channel
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   resource: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580888 = newJObject()
  var body_580889 = newJObject()
  add(query_580888, "key", newJString(key))
  add(query_580888, "prettyPrint", newJBool(prettyPrint))
  add(query_580888, "oauth_token", newJString(oauthToken))
  add(query_580888, "alt", newJString(alt))
  add(query_580888, "userIp", newJString(userIp))
  add(query_580888, "quotaUser", newJString(quotaUser))
  if resource != nil:
    body_580889 = resource
  add(query_580888, "fields", newJString(fields))
  result = call_580887.call(nil, query_580888, nil, nil, body_580889)

var storageChannelsStop* = Call_StorageChannelsStop_580875(
    name: "storageChannelsStop", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_StorageChannelsStop_580876, base: "/storage/v1",
    url: url_StorageChannelsStop_580877, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysCreate_580910 = ref object of OpenApiRestCall_579380
proc url_StorageProjectsHmacKeysCreate_580912(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysCreate_580911(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new HMAC key for the specified service account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID owning the service account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580913 = path.getOrDefault("projectId")
  valid_580913 = validateParameter(valid_580913, JString, required = true,
                                 default = nil)
  if valid_580913 != nil:
    section.add "projectId", valid_580913
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   serviceAccountEmail: JString (required)
  ##                      : Email address of the service account.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580914 = query.getOrDefault("key")
  valid_580914 = validateParameter(valid_580914, JString, required = false,
                                 default = nil)
  if valid_580914 != nil:
    section.add "key", valid_580914
  var valid_580915 = query.getOrDefault("prettyPrint")
  valid_580915 = validateParameter(valid_580915, JBool, required = false,
                                 default = newJBool(true))
  if valid_580915 != nil:
    section.add "prettyPrint", valid_580915
  var valid_580916 = query.getOrDefault("oauth_token")
  valid_580916 = validateParameter(valid_580916, JString, required = false,
                                 default = nil)
  if valid_580916 != nil:
    section.add "oauth_token", valid_580916
  var valid_580917 = query.getOrDefault("userProject")
  valid_580917 = validateParameter(valid_580917, JString, required = false,
                                 default = nil)
  if valid_580917 != nil:
    section.add "userProject", valid_580917
  var valid_580918 = query.getOrDefault("alt")
  valid_580918 = validateParameter(valid_580918, JString, required = false,
                                 default = newJString("json"))
  if valid_580918 != nil:
    section.add "alt", valid_580918
  var valid_580919 = query.getOrDefault("userIp")
  valid_580919 = validateParameter(valid_580919, JString, required = false,
                                 default = nil)
  if valid_580919 != nil:
    section.add "userIp", valid_580919
  var valid_580920 = query.getOrDefault("quotaUser")
  valid_580920 = validateParameter(valid_580920, JString, required = false,
                                 default = nil)
  if valid_580920 != nil:
    section.add "quotaUser", valid_580920
  assert query != nil, "query argument is necessary due to required `serviceAccountEmail` field"
  var valid_580921 = query.getOrDefault("serviceAccountEmail")
  valid_580921 = validateParameter(valid_580921, JString, required = true,
                                 default = nil)
  if valid_580921 != nil:
    section.add "serviceAccountEmail", valid_580921
  var valid_580922 = query.getOrDefault("fields")
  valid_580922 = validateParameter(valid_580922, JString, required = false,
                                 default = nil)
  if valid_580922 != nil:
    section.add "fields", valid_580922
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580923: Call_StorageProjectsHmacKeysCreate_580910; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new HMAC key for the specified service account.
  ## 
  let valid = call_580923.validator(path, query, header, formData, body)
  let scheme = call_580923.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580923.url(scheme.get, call_580923.host, call_580923.base,
                         call_580923.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580923, url, valid)

proc call*(call_580924: Call_StorageProjectsHmacKeysCreate_580910;
          projectId: string; serviceAccountEmail: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## storageProjectsHmacKeysCreate
  ## Creates a new HMAC key for the specified service account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID owning the service account.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   serviceAccountEmail: string (required)
  ##                      : Email address of the service account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580925 = newJObject()
  var query_580926 = newJObject()
  add(query_580926, "key", newJString(key))
  add(query_580926, "prettyPrint", newJBool(prettyPrint))
  add(query_580926, "oauth_token", newJString(oauthToken))
  add(path_580925, "projectId", newJString(projectId))
  add(query_580926, "userProject", newJString(userProject))
  add(query_580926, "alt", newJString(alt))
  add(query_580926, "userIp", newJString(userIp))
  add(query_580926, "quotaUser", newJString(quotaUser))
  add(query_580926, "serviceAccountEmail", newJString(serviceAccountEmail))
  add(query_580926, "fields", newJString(fields))
  result = call_580924.call(path_580925, query_580926, nil, nil, nil)

var storageProjectsHmacKeysCreate* = Call_StorageProjectsHmacKeysCreate_580910(
    name: "storageProjectsHmacKeysCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/projects/{projectId}/hmacKeys",
    validator: validate_StorageProjectsHmacKeysCreate_580911, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysCreate_580912, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysList_580890 = ref object of OpenApiRestCall_579380
proc url_StorageProjectsHmacKeysList_580892(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysList_580891(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of HMAC keys matching the criteria.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Name of the project in which to look for HMAC keys.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580893 = path.getOrDefault("projectId")
  valid_580893 = validateParameter(valid_580893, JString, required = true,
                                 default = nil)
  if valid_580893 != nil:
    section.add "projectId", valid_580893
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   showDeletedKeys: JBool
  ##                  : Whether or not to show keys in the DELETED state.
  ##   serviceAccountEmail: JString
  ##                      : If present, only keys for the given service account are returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of items to return in a single page of responses. The service uses this parameter or 250 items, whichever is smaller. The max number of items per page will also be limited by the number of distinct service accounts in the response. If the number of service accounts in a single response is too high, the page will truncated and a next page token will be returned.
  section = newJObject()
  var valid_580894 = query.getOrDefault("key")
  valid_580894 = validateParameter(valid_580894, JString, required = false,
                                 default = nil)
  if valid_580894 != nil:
    section.add "key", valid_580894
  var valid_580895 = query.getOrDefault("prettyPrint")
  valid_580895 = validateParameter(valid_580895, JBool, required = false,
                                 default = newJBool(true))
  if valid_580895 != nil:
    section.add "prettyPrint", valid_580895
  var valid_580896 = query.getOrDefault("oauth_token")
  valid_580896 = validateParameter(valid_580896, JString, required = false,
                                 default = nil)
  if valid_580896 != nil:
    section.add "oauth_token", valid_580896
  var valid_580897 = query.getOrDefault("userProject")
  valid_580897 = validateParameter(valid_580897, JString, required = false,
                                 default = nil)
  if valid_580897 != nil:
    section.add "userProject", valid_580897
  var valid_580898 = query.getOrDefault("alt")
  valid_580898 = validateParameter(valid_580898, JString, required = false,
                                 default = newJString("json"))
  if valid_580898 != nil:
    section.add "alt", valid_580898
  var valid_580899 = query.getOrDefault("userIp")
  valid_580899 = validateParameter(valid_580899, JString, required = false,
                                 default = nil)
  if valid_580899 != nil:
    section.add "userIp", valid_580899
  var valid_580900 = query.getOrDefault("quotaUser")
  valid_580900 = validateParameter(valid_580900, JString, required = false,
                                 default = nil)
  if valid_580900 != nil:
    section.add "quotaUser", valid_580900
  var valid_580901 = query.getOrDefault("pageToken")
  valid_580901 = validateParameter(valid_580901, JString, required = false,
                                 default = nil)
  if valid_580901 != nil:
    section.add "pageToken", valid_580901
  var valid_580902 = query.getOrDefault("showDeletedKeys")
  valid_580902 = validateParameter(valid_580902, JBool, required = false, default = nil)
  if valid_580902 != nil:
    section.add "showDeletedKeys", valid_580902
  var valid_580903 = query.getOrDefault("serviceAccountEmail")
  valid_580903 = validateParameter(valid_580903, JString, required = false,
                                 default = nil)
  if valid_580903 != nil:
    section.add "serviceAccountEmail", valid_580903
  var valid_580904 = query.getOrDefault("fields")
  valid_580904 = validateParameter(valid_580904, JString, required = false,
                                 default = nil)
  if valid_580904 != nil:
    section.add "fields", valid_580904
  var valid_580905 = query.getOrDefault("maxResults")
  valid_580905 = validateParameter(valid_580905, JInt, required = false,
                                 default = newJInt(250))
  if valid_580905 != nil:
    section.add "maxResults", valid_580905
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580906: Call_StorageProjectsHmacKeysList_580890; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of HMAC keys matching the criteria.
  ## 
  let valid = call_580906.validator(path, query, header, formData, body)
  let scheme = call_580906.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580906.url(scheme.get, call_580906.host, call_580906.base,
                         call_580906.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580906, url, valid)

proc call*(call_580907: Call_StorageProjectsHmacKeysList_580890; projectId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; showDeletedKeys: bool = false;
          serviceAccountEmail: string = ""; fields: string = ""; maxResults: int = 250): Recallable =
  ## storageProjectsHmacKeysList
  ## Retrieves a list of HMAC keys matching the criteria.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Name of the project in which to look for HMAC keys.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   showDeletedKeys: bool
  ##                  : Whether or not to show keys in the DELETED state.
  ##   serviceAccountEmail: string
  ##                      : If present, only keys for the given service account are returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of items to return in a single page of responses. The service uses this parameter or 250 items, whichever is smaller. The max number of items per page will also be limited by the number of distinct service accounts in the response. If the number of service accounts in a single response is too high, the page will truncated and a next page token will be returned.
  var path_580908 = newJObject()
  var query_580909 = newJObject()
  add(query_580909, "key", newJString(key))
  add(query_580909, "prettyPrint", newJBool(prettyPrint))
  add(query_580909, "oauth_token", newJString(oauthToken))
  add(path_580908, "projectId", newJString(projectId))
  add(query_580909, "userProject", newJString(userProject))
  add(query_580909, "alt", newJString(alt))
  add(query_580909, "userIp", newJString(userIp))
  add(query_580909, "quotaUser", newJString(quotaUser))
  add(query_580909, "pageToken", newJString(pageToken))
  add(query_580909, "showDeletedKeys", newJBool(showDeletedKeys))
  add(query_580909, "serviceAccountEmail", newJString(serviceAccountEmail))
  add(query_580909, "fields", newJString(fields))
  add(query_580909, "maxResults", newJInt(maxResults))
  result = call_580907.call(path_580908, query_580909, nil, nil, nil)

var storageProjectsHmacKeysList* = Call_StorageProjectsHmacKeysList_580890(
    name: "storageProjectsHmacKeysList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/projects/{projectId}/hmacKeys",
    validator: validate_StorageProjectsHmacKeysList_580891, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysList_580892, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysUpdate_580944 = ref object of OpenApiRestCall_579380
proc url_StorageProjectsHmacKeysUpdate_580946(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "accessId" in path, "`accessId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys/"),
               (kind: VariableSegment, value: "accessId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysUpdate_580945(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the state of an HMAC key. See the HMAC Key resource descriptor for valid states.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID owning the service account of the updated key.
  ##   accessId: JString (required)
  ##           : Name of the HMAC key being updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580947 = path.getOrDefault("projectId")
  valid_580947 = validateParameter(valid_580947, JString, required = true,
                                 default = nil)
  if valid_580947 != nil:
    section.add "projectId", valid_580947
  var valid_580948 = path.getOrDefault("accessId")
  valid_580948 = validateParameter(valid_580948, JString, required = true,
                                 default = nil)
  if valid_580948 != nil:
    section.add "accessId", valid_580948
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580949 = query.getOrDefault("key")
  valid_580949 = validateParameter(valid_580949, JString, required = false,
                                 default = nil)
  if valid_580949 != nil:
    section.add "key", valid_580949
  var valid_580950 = query.getOrDefault("prettyPrint")
  valid_580950 = validateParameter(valid_580950, JBool, required = false,
                                 default = newJBool(true))
  if valid_580950 != nil:
    section.add "prettyPrint", valid_580950
  var valid_580951 = query.getOrDefault("oauth_token")
  valid_580951 = validateParameter(valid_580951, JString, required = false,
                                 default = nil)
  if valid_580951 != nil:
    section.add "oauth_token", valid_580951
  var valid_580952 = query.getOrDefault("userProject")
  valid_580952 = validateParameter(valid_580952, JString, required = false,
                                 default = nil)
  if valid_580952 != nil:
    section.add "userProject", valid_580952
  var valid_580953 = query.getOrDefault("alt")
  valid_580953 = validateParameter(valid_580953, JString, required = false,
                                 default = newJString("json"))
  if valid_580953 != nil:
    section.add "alt", valid_580953
  var valid_580954 = query.getOrDefault("userIp")
  valid_580954 = validateParameter(valid_580954, JString, required = false,
                                 default = nil)
  if valid_580954 != nil:
    section.add "userIp", valid_580954
  var valid_580955 = query.getOrDefault("quotaUser")
  valid_580955 = validateParameter(valid_580955, JString, required = false,
                                 default = nil)
  if valid_580955 != nil:
    section.add "quotaUser", valid_580955
  var valid_580956 = query.getOrDefault("fields")
  valid_580956 = validateParameter(valid_580956, JString, required = false,
                                 default = nil)
  if valid_580956 != nil:
    section.add "fields", valid_580956
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

proc call*(call_580958: Call_StorageProjectsHmacKeysUpdate_580944; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the state of an HMAC key. See the HMAC Key resource descriptor for valid states.
  ## 
  let valid = call_580958.validator(path, query, header, formData, body)
  let scheme = call_580958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580958.url(scheme.get, call_580958.host, call_580958.base,
                         call_580958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580958, url, valid)

proc call*(call_580959: Call_StorageProjectsHmacKeysUpdate_580944;
          projectId: string; accessId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageProjectsHmacKeysUpdate
  ## Updates the state of an HMAC key. See the HMAC Key resource descriptor for valid states.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID owning the service account of the updated key.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accessId: string (required)
  ##           : Name of the HMAC key being updated.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580960 = newJObject()
  var query_580961 = newJObject()
  var body_580962 = newJObject()
  add(query_580961, "key", newJString(key))
  add(query_580961, "prettyPrint", newJBool(prettyPrint))
  add(query_580961, "oauth_token", newJString(oauthToken))
  add(path_580960, "projectId", newJString(projectId))
  add(query_580961, "userProject", newJString(userProject))
  add(query_580961, "alt", newJString(alt))
  add(query_580961, "userIp", newJString(userIp))
  add(query_580961, "quotaUser", newJString(quotaUser))
  add(path_580960, "accessId", newJString(accessId))
  if body != nil:
    body_580962 = body
  add(query_580961, "fields", newJString(fields))
  result = call_580959.call(path_580960, query_580961, nil, nil, body_580962)

var storageProjectsHmacKeysUpdate* = Call_StorageProjectsHmacKeysUpdate_580944(
    name: "storageProjectsHmacKeysUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/projects/{projectId}/hmacKeys/{accessId}",
    validator: validate_StorageProjectsHmacKeysUpdate_580945, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysUpdate_580946, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysGet_580927 = ref object of OpenApiRestCall_579380
proc url_StorageProjectsHmacKeysGet_580929(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "accessId" in path, "`accessId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys/"),
               (kind: VariableSegment, value: "accessId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysGet_580928(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves an HMAC key's metadata
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID owning the service account of the requested key.
  ##   accessId: JString (required)
  ##           : Name of the HMAC key.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580930 = path.getOrDefault("projectId")
  valid_580930 = validateParameter(valid_580930, JString, required = true,
                                 default = nil)
  if valid_580930 != nil:
    section.add "projectId", valid_580930
  var valid_580931 = path.getOrDefault("accessId")
  valid_580931 = validateParameter(valid_580931, JString, required = true,
                                 default = nil)
  if valid_580931 != nil:
    section.add "accessId", valid_580931
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580932 = query.getOrDefault("key")
  valid_580932 = validateParameter(valid_580932, JString, required = false,
                                 default = nil)
  if valid_580932 != nil:
    section.add "key", valid_580932
  var valid_580933 = query.getOrDefault("prettyPrint")
  valid_580933 = validateParameter(valid_580933, JBool, required = false,
                                 default = newJBool(true))
  if valid_580933 != nil:
    section.add "prettyPrint", valid_580933
  var valid_580934 = query.getOrDefault("oauth_token")
  valid_580934 = validateParameter(valid_580934, JString, required = false,
                                 default = nil)
  if valid_580934 != nil:
    section.add "oauth_token", valid_580934
  var valid_580935 = query.getOrDefault("userProject")
  valid_580935 = validateParameter(valid_580935, JString, required = false,
                                 default = nil)
  if valid_580935 != nil:
    section.add "userProject", valid_580935
  var valid_580936 = query.getOrDefault("alt")
  valid_580936 = validateParameter(valid_580936, JString, required = false,
                                 default = newJString("json"))
  if valid_580936 != nil:
    section.add "alt", valid_580936
  var valid_580937 = query.getOrDefault("userIp")
  valid_580937 = validateParameter(valid_580937, JString, required = false,
                                 default = nil)
  if valid_580937 != nil:
    section.add "userIp", valid_580937
  var valid_580938 = query.getOrDefault("quotaUser")
  valid_580938 = validateParameter(valid_580938, JString, required = false,
                                 default = nil)
  if valid_580938 != nil:
    section.add "quotaUser", valid_580938
  var valid_580939 = query.getOrDefault("fields")
  valid_580939 = validateParameter(valid_580939, JString, required = false,
                                 default = nil)
  if valid_580939 != nil:
    section.add "fields", valid_580939
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580940: Call_StorageProjectsHmacKeysGet_580927; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an HMAC key's metadata
  ## 
  let valid = call_580940.validator(path, query, header, formData, body)
  let scheme = call_580940.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580940.url(scheme.get, call_580940.host, call_580940.base,
                         call_580940.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580940, url, valid)

proc call*(call_580941: Call_StorageProjectsHmacKeysGet_580927; projectId: string;
          accessId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageProjectsHmacKeysGet
  ## Retrieves an HMAC key's metadata
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID owning the service account of the requested key.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accessId: string (required)
  ##           : Name of the HMAC key.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580942 = newJObject()
  var query_580943 = newJObject()
  add(query_580943, "key", newJString(key))
  add(query_580943, "prettyPrint", newJBool(prettyPrint))
  add(query_580943, "oauth_token", newJString(oauthToken))
  add(path_580942, "projectId", newJString(projectId))
  add(query_580943, "userProject", newJString(userProject))
  add(query_580943, "alt", newJString(alt))
  add(query_580943, "userIp", newJString(userIp))
  add(query_580943, "quotaUser", newJString(quotaUser))
  add(path_580942, "accessId", newJString(accessId))
  add(query_580943, "fields", newJString(fields))
  result = call_580941.call(path_580942, query_580943, nil, nil, nil)

var storageProjectsHmacKeysGet* = Call_StorageProjectsHmacKeysGet_580927(
    name: "storageProjectsHmacKeysGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/projects/{projectId}/hmacKeys/{accessId}",
    validator: validate_StorageProjectsHmacKeysGet_580928, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysGet_580929, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysDelete_580963 = ref object of OpenApiRestCall_579380
proc url_StorageProjectsHmacKeysDelete_580965(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "accessId" in path, "`accessId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys/"),
               (kind: VariableSegment, value: "accessId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysDelete_580964(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an HMAC key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID owning the requested key
  ##   accessId: JString (required)
  ##           : Name of the HMAC key to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580966 = path.getOrDefault("projectId")
  valid_580966 = validateParameter(valid_580966, JString, required = true,
                                 default = nil)
  if valid_580966 != nil:
    section.add "projectId", valid_580966
  var valid_580967 = path.getOrDefault("accessId")
  valid_580967 = validateParameter(valid_580967, JString, required = true,
                                 default = nil)
  if valid_580967 != nil:
    section.add "accessId", valid_580967
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580968 = query.getOrDefault("key")
  valid_580968 = validateParameter(valid_580968, JString, required = false,
                                 default = nil)
  if valid_580968 != nil:
    section.add "key", valid_580968
  var valid_580969 = query.getOrDefault("prettyPrint")
  valid_580969 = validateParameter(valid_580969, JBool, required = false,
                                 default = newJBool(true))
  if valid_580969 != nil:
    section.add "prettyPrint", valid_580969
  var valid_580970 = query.getOrDefault("oauth_token")
  valid_580970 = validateParameter(valid_580970, JString, required = false,
                                 default = nil)
  if valid_580970 != nil:
    section.add "oauth_token", valid_580970
  var valid_580971 = query.getOrDefault("userProject")
  valid_580971 = validateParameter(valid_580971, JString, required = false,
                                 default = nil)
  if valid_580971 != nil:
    section.add "userProject", valid_580971
  var valid_580972 = query.getOrDefault("alt")
  valid_580972 = validateParameter(valid_580972, JString, required = false,
                                 default = newJString("json"))
  if valid_580972 != nil:
    section.add "alt", valid_580972
  var valid_580973 = query.getOrDefault("userIp")
  valid_580973 = validateParameter(valid_580973, JString, required = false,
                                 default = nil)
  if valid_580973 != nil:
    section.add "userIp", valid_580973
  var valid_580974 = query.getOrDefault("quotaUser")
  valid_580974 = validateParameter(valid_580974, JString, required = false,
                                 default = nil)
  if valid_580974 != nil:
    section.add "quotaUser", valid_580974
  var valid_580975 = query.getOrDefault("fields")
  valid_580975 = validateParameter(valid_580975, JString, required = false,
                                 default = nil)
  if valid_580975 != nil:
    section.add "fields", valid_580975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580976: Call_StorageProjectsHmacKeysDelete_580963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an HMAC key.
  ## 
  let valid = call_580976.validator(path, query, header, formData, body)
  let scheme = call_580976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580976.url(scheme.get, call_580976.host, call_580976.base,
                         call_580976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580976, url, valid)

proc call*(call_580977: Call_StorageProjectsHmacKeysDelete_580963;
          projectId: string; accessId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## storageProjectsHmacKeysDelete
  ## Deletes an HMAC key.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID owning the requested key
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accessId: string (required)
  ##           : Name of the HMAC key to be deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580978 = newJObject()
  var query_580979 = newJObject()
  add(query_580979, "key", newJString(key))
  add(query_580979, "prettyPrint", newJBool(prettyPrint))
  add(query_580979, "oauth_token", newJString(oauthToken))
  add(path_580978, "projectId", newJString(projectId))
  add(query_580979, "userProject", newJString(userProject))
  add(query_580979, "alt", newJString(alt))
  add(query_580979, "userIp", newJString(userIp))
  add(query_580979, "quotaUser", newJString(quotaUser))
  add(path_580978, "accessId", newJString(accessId))
  add(query_580979, "fields", newJString(fields))
  result = call_580977.call(path_580978, query_580979, nil, nil, nil)

var storageProjectsHmacKeysDelete* = Call_StorageProjectsHmacKeysDelete_580963(
    name: "storageProjectsHmacKeysDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/projects/{projectId}/hmacKeys/{accessId}",
    validator: validate_StorageProjectsHmacKeysDelete_580964, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysDelete_580965, schemes: {Scheme.Https})
type
  Call_StorageProjectsServiceAccountGet_580980 = ref object of OpenApiRestCall_579380
proc url_StorageProjectsServiceAccountGet_580982(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/serviceAccount")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageProjectsServiceAccountGet_580981(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the email address of this project's Google Cloud Storage service account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580983 = path.getOrDefault("projectId")
  valid_580983 = validateParameter(valid_580983, JString, required = true,
                                 default = nil)
  if valid_580983 != nil:
    section.add "projectId", valid_580983
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580984 = query.getOrDefault("key")
  valid_580984 = validateParameter(valid_580984, JString, required = false,
                                 default = nil)
  if valid_580984 != nil:
    section.add "key", valid_580984
  var valid_580985 = query.getOrDefault("prettyPrint")
  valid_580985 = validateParameter(valid_580985, JBool, required = false,
                                 default = newJBool(true))
  if valid_580985 != nil:
    section.add "prettyPrint", valid_580985
  var valid_580986 = query.getOrDefault("oauth_token")
  valid_580986 = validateParameter(valid_580986, JString, required = false,
                                 default = nil)
  if valid_580986 != nil:
    section.add "oauth_token", valid_580986
  var valid_580987 = query.getOrDefault("userProject")
  valid_580987 = validateParameter(valid_580987, JString, required = false,
                                 default = nil)
  if valid_580987 != nil:
    section.add "userProject", valid_580987
  var valid_580988 = query.getOrDefault("alt")
  valid_580988 = validateParameter(valid_580988, JString, required = false,
                                 default = newJString("json"))
  if valid_580988 != nil:
    section.add "alt", valid_580988
  var valid_580989 = query.getOrDefault("userIp")
  valid_580989 = validateParameter(valid_580989, JString, required = false,
                                 default = nil)
  if valid_580989 != nil:
    section.add "userIp", valid_580989
  var valid_580990 = query.getOrDefault("quotaUser")
  valid_580990 = validateParameter(valid_580990, JString, required = false,
                                 default = nil)
  if valid_580990 != nil:
    section.add "quotaUser", valid_580990
  var valid_580991 = query.getOrDefault("provisionalUserProject")
  valid_580991 = validateParameter(valid_580991, JString, required = false,
                                 default = nil)
  if valid_580991 != nil:
    section.add "provisionalUserProject", valid_580991
  var valid_580992 = query.getOrDefault("fields")
  valid_580992 = validateParameter(valid_580992, JString, required = false,
                                 default = nil)
  if valid_580992 != nil:
    section.add "fields", valid_580992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580993: Call_StorageProjectsServiceAccountGet_580980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the email address of this project's Google Cloud Storage service account.
  ## 
  let valid = call_580993.validator(path, query, header, formData, body)
  let scheme = call_580993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580993.url(scheme.get, call_580993.host, call_580993.base,
                         call_580993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580993, url, valid)

proc call*(call_580994: Call_StorageProjectsServiceAccountGet_580980;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageProjectsServiceAccountGet
  ## Get the email address of this project's Google Cloud Storage service account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580995 = newJObject()
  var query_580996 = newJObject()
  add(query_580996, "key", newJString(key))
  add(query_580996, "prettyPrint", newJBool(prettyPrint))
  add(query_580996, "oauth_token", newJString(oauthToken))
  add(path_580995, "projectId", newJString(projectId))
  add(query_580996, "userProject", newJString(userProject))
  add(query_580996, "alt", newJString(alt))
  add(query_580996, "userIp", newJString(userIp))
  add(query_580996, "quotaUser", newJString(quotaUser))
  add(query_580996, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_580996, "fields", newJString(fields))
  result = call_580994.call(path_580995, query_580996, nil, nil, nil)

var storageProjectsServiceAccountGet* = Call_StorageProjectsServiceAccountGet_580980(
    name: "storageProjectsServiceAccountGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/projects/{projectId}/serviceAccount",
    validator: validate_StorageProjectsServiceAccountGet_580981,
    base: "/storage/v1", url: url_StorageProjectsServiceAccountGet_580982,
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
